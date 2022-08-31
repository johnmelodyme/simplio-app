import 'package:flutter/material.dart';
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
      allowDuplicates: false,
      controller: MobileScannerController(
          facing: CameraFacing.back, torchEnabled: true),
      onDetect: (barcode, args) {
        if (barcode.rawValue == null) {
          debugPrint('Failed to scan Barcode');
          errorCallback();
        } else {
          final String code = barcode.rawValue!;
          qrCodeCallback(code);
          debugPrint('Barcode found! $code');
        }
      },
    );
  }
}
