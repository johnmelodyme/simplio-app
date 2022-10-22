import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  final ValueChanged<String> qrCodeCallback;
  final Function() errorCallback;
  final Function() closedCallback;

  const QrCodeScanner({
    super.key,
    required this.qrCodeCallback,
    required this.errorCallback,
    required this.closedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: MobileScannerController(
        torchEnabled: false,
      ),
      onDetect: (barcode, args) {
        if (barcode.rawValue == null) {
          debugPrint('Failed to scan Barcode');
          errorCallback();
        } else {
          final String code = barcode.rawValue!;
          HapticFeedback.vibrate();
          debugPrint('Barcode found! $code');

          qrCodeCallback(code);
        }
      },
    );
  }
}
