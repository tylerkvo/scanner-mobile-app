import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:scanner/scan.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    var tempController =
        CameraController(cameras[0], ResolutionPreset.veryHigh);
    await tempController.initialize();
    setState(() {
      controller = tempController;
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  @override
  void dispose() {
    controller?.dispose(); // Dispose safely
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Scan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: false),
        body: Container(
            width: double.infinity,
            color: Colors.black,
            child: (controller == null || !controller!.value.isInitialized)
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(child: CameraPreview(controller!)),
                      GestureDetector(
                          onTap: () async {
                            final photo = await controller!.takePicture();
                            controller!.pausePreview();
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScanScreen(
                                        image: File(photo.path))));
                            controller!.resumePreview();
                          },
                          child: Container(
                              width: 70,
                              height: 70,
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          155, 155, 155, 0.4),
                                      width: 5))))
                    ],
                  )));
  }
}
