import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

typedef QrCodeValidator = bool Function(String value);

class QrCodeScanner extends StatefulWidget {
  final QrCodeValidator validator;
  final ValueChanged<String> onScan;
  final void Function(Exception? error) onError;

  const QrCodeScanner({
    super.key,
    required this.validator,
    required this.onScan,
    required this.onError,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final mobileScannerController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: mobileScannerController,
      onDetect: (barcode, _) {
        final value = barcode.rawValue;

        if (value == null || barcode.format != BarcodeFormat.qrCode) {
          return widget.onError(null);
        }

        if (widget.validator(value)) return widget.onScan(value);

        mobileScannerController.start().onError((error, stackTrace) {
          widget.onError(Exception('Error starting scanner: $error'));
        });
      },
    );
  }
}
