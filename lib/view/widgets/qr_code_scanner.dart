import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:simplio_app/data/repositories/helpers/wallet_connect_uri_validator.dart';
import 'package:simplio_app/l10n/localized_build_context_extension.dart';
import 'package:simplio_app/view/screens/mixins/popup_dialog_mixin.dart';
import 'package:sio_core_light/sio_core_light.dart' as sio;

enum QrCodeType { address, walletConnectUri }

class QrCodeScanner extends StatelessWidget with PopupDialogMixin {
  final QrCodeType qrCodeType;
  final ValueChanged<String> qrCodeCallback;
  final int? networkId;
  final Function() errorCallback;
  final Function() closedCallback;
  final mobileScannerController = MobileScannerController(
    torchEnabled: false,
  );

  QrCodeScanner({
    super.key,
    required this.qrCodeType,
    required this.qrCodeCallback,
    this.networkId,
    required this.errorCallback,
    required this.closedCallback,
  }) : assert(
          qrCodeType == QrCodeType.address ? networkId != null : true,
          'NetworkId needs to be specified for Address type',
        );

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: mobileScannerController,
      onDetect: (barcode, args) {
        if (barcode.rawValue == null ||
            barcode.format != BarcodeFormat.qrCode) {
          // debugPrint('Failed to scan Barcode');
          errorCallback();
        } else {
          final String code = barcode.rawValue!;
          HapticFeedback.vibrate();

          switch (qrCodeType) {
            case QrCodeType.walletConnectUri:
              if (!WalletConnectUriValidator.validate(code)) {
                mobileScannerController.stop();
                showError(context,
                    message:
                        context.locale.qr_code_scanner_wallet_connect_error,
                    afterHideAction: errorCallback);

                Future.delayed(
                    const Duration(seconds: 2), mobileScannerController.start);

                return;
              }
              break;
            case QrCodeType.address:
              if (!sio.Address.isValid(address: code, networkId: networkId!)) {
                mobileScannerController.stop();
                showError(context,
                    message: context.locale.qr_code_scanner_address_error,
                    afterHideAction: errorCallback);

                Future.delayed(
                    const Duration(seconds: 2), mobileScannerController.start);

                return;
              }
              break;
          }

          qrCodeCallback(code);
        }
      },
    );
  }
}
