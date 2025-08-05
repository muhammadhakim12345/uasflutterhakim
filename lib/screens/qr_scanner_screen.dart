import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? _scannedData;
  Map<String, dynamic>? _parsedData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan QR codes'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _scannedData = barcode.rawValue;
        });
        
        try {
          // Try to parse as JSON
          final parsed = json.decode(barcode.rawValue!);
          setState(() {
            _parsedData = parsed;
          });
          
          // If parsed data contains nama and nobp, save to database
          if (parsed.containsKey('nama') && parsed.containsKey('nobp')) {
            _saveToDatabase(parsed['nama'], parsed['nobp']);
          }
        } catch (e) {
          // If not JSON, treat as plain text
          setState(() {
            _parsedData = {'text': barcode.rawValue};
          });
        }

        // Stop scanning after successful scan
        cameraController.stop();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('QR Code detected: ${barcode.rawValue}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;
      }
    }
  }

  Future<void> _saveToDatabase(String nama, String nobp) async {
    setState(() {
      _isSaving = true;
    });

    try {
      await ApiService.createUsashakim(nama, nobp);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data $nama berhasil disimpan ke database!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error menyimpan data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return Icon(
                  state == TorchState.off ? Icons.flash_off : Icons.flash_on,
                );
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return Icon(
                  state == CameraFacing.front ? Icons.camera_front : Icons.camera_rear,
                );
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onDetect,
                ),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Scan QR Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Scanner overlay
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_scannedData != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scanned Data:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_parsedData != null && _parsedData!.containsKey('nama')) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.blue),
                                const SizedBox(width: 8),
                                const Text(
                                  'Nama:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(_parsedData!['nama']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.badge, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text(
                                  'No BP:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(_parsedData!['nobp']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(_scannedData!),
                      ),
                    ),
                  ],
                                     const SizedBox(height: 16),
                   if (_isSaving) ...[
                     const Row(
                       children: [
                         Expanded(
                           child: Card(
                             child: Padding(
                               padding: EdgeInsets.all(16),
                               child: Row(
                                 children: [
                                   SizedBox(
                                     width: 20,
                                     height: 20,
                                     child: CircularProgressIndicator(strokeWidth: 2),
                                   ),
                                   SizedBox(width: 16),
                                   Text('Menyimpan data ke database...'),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 16),
                   ],
                   Row(
                     children: [
                       Expanded(
                         child: ElevatedButton.icon(
                           onPressed: _isSaving ? null : () {
                             setState(() {
                               _scannedData = null;
                               _parsedData = null;
                             });
                             cameraController.start();
                           },
                           icon: const Icon(Icons.refresh),
                           label: const Text('Scan Again'),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.blue,
                             foregroundColor: Colors.white,
                           ),
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
} 