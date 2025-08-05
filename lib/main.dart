import 'package:flutter/material.dart';
import 'screens/qr_generator_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/data_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 32),
            const Text(
              'QR Code Generator & Scanner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi untuk generate QR code dari data nama dan No BP, serta scan QR code menggunakan kamera',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildMenuCard(
              context,
              'Generate QR Code',
              'Buat QR code dari input nama dan No BP',
              Icons.qr_code,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRGeneratorScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              'Scan QR Code',
              'Scan QR code menggunakan kamera',
              Icons.qr_code_scanner,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRScannerScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuCard(
              context,
              'Data List',
              'Lihat semua data yang tersimpan',
              Icons.list,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DataListScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
