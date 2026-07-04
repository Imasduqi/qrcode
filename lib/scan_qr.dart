import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  String? _scannedData;
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    if (_scannedData != null) {
      Clipboard.setData(ClipboardData(text: _scannedData!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hasil scan berhasil disalin ke clipboard!'),
          backgroundColor: Color(0xFF1A237E),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subtitle instruction
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              'Arahkan kamera ke QR Code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Camera preview area with Scan window overlay
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Scanner view
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final value = barcode.rawValue;
                          if (value != null && value.isNotEmpty) {
                            if (_scannedData != value) {
                              setState(() {
                                _scannedData = value;
                              });
                            }
                          }
                        }
                      },
                      errorBuilder: (context, error) {
                        String errorMessage = 'Terjadi kesalahan pada kamera.';
                        if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
                          errorMessage = 'Izin kamera ditolak. Silakan aktifkan izin kamera di Pengaturan perangkat Anda.';
                        }
                        return Container(
                          color: Colors.black87,
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.videocam_off_rounded,
                                  color: Colors.redAccent,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    // Outer border and corner overlay
                    CustomPaint(
                      painter: ScanBorderPainter(),
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scan result card
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Hasil Scan:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE), // Light gray card background from SPEC.md
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: _scannedData == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Belum ada hasil scan',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SelectableText(
                              _scannedData!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _copyToClipboard,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  minimumSize: Size.zero,
                                ),
                                icon: const Icon(Icons.copy_rounded, size: 16),
                                label: const Text(
                                  'Salin Hasil',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScanBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.4) // Semi-transparent dark overlay
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Scan box dimensions (centered square)
    final scanSize = 220.0;
    final left = (width - scanSize) / 2;
    final top = (height - scanSize) / 2;
    final right = left + scanSize;
    final bottom = top + scanSize;

    // Draw the dark overlays outside the scanning square
    // Top
    canvas.drawRect(Rect.fromLTRB(0, 0, width, top), paint);
    // Left
    canvas.drawRect(Rect.fromLTRB(0, top, left, bottom), paint);
    // Right
    canvas.drawRect(Rect.fromLTRB(right, top, width, bottom), paint);
    // Bottom
    canvas.drawRect(Rect.fromLTRB(0, bottom, width, height), paint);

    // Draw scanning border corner brackets (Indigo color)
    final borderPaint = Paint()
      ..color = const Color(0xFF1A237E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const cornerLength = 20.0;

    // Top-Left corner
    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), borderPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), borderPaint);

    // Top-Right corner
    canvas.drawLine(Offset(right, top), Offset(right - cornerLength, top), borderPaint);
    canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), borderPaint);

    // Bottom-Left corner
    canvas.drawLine(Offset(left, bottom), Offset(left + cornerLength, bottom), borderPaint);
    canvas.drawLine(Offset(left, bottom), Offset(left, bottom - cornerLength), borderPaint);

    // Bottom-Right corner
    canvas.drawLine(Offset(right, bottom), Offset(right - cornerLength, bottom), borderPaint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
