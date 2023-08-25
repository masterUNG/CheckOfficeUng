import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  ScanController scanController = ScanController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scanController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScanView(
        controller: scanController,
        onCapture: (data) {
          print('data ---> $data');
        },
      ),
    );
  }
}
