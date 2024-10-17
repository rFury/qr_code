import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart'; // Import the barcode_scan2 package
import 'package:permission_handler/permission_handler.dart'; // Import the permission handler package
import 'package:qr_code/Functions/encode_decode.dart';
import 'Resources/FormScreen.dart';  // Import the form screen

void main() {
  runApp(const QRApp());
}

class QRApp extends StatelessWidget {
  const QRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QRCodeGeneratorScreen(),
    );
  }
}

class QRCodeGeneratorScreen extends StatefulWidget {
  const QRCodeGeneratorScreen({super.key});

  @override
  _QRCodeGeneratorScreenState createState() => _QRCodeGeneratorScreenState();
}

class _QRCodeGeneratorScreenState extends State<QRCodeGeneratorScreen> {
  String qrCodeData = ""; 

  Future<void> scanQRCode() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      await Permission.camera.request();
    }

    if (await Permission.camera.isGranted) {
      try {
        var result = await BarcodeScanner.scan(); // Start scanning
        setState(() {
          qrCodeData = result.rawContent.isNotEmpty
              ? result.rawContent
              : "QR code not recognized!";
        });
      } catch (e) {
        setState(() {
          qrCodeData = "Failed to scan QR code: $e";
        });
      }
    } else {
      setState(() {
        qrCodeData = "Camera permission denied!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Reader'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Button to scan QR code
            ElevatedButton(
              onPressed: scanQRCode,
              child: const Text('Scan QR Code'),
            ),
            const SizedBox(height: 20),

            // Display scanned QR code data
            Text(
              'Scanned QR Code Data: '+decodeFromHLV(qrCodeData).toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Button to navigate to the Form Screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
              },
              child: const Text('Go to Form Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
