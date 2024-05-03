/*
Used Flutter guide to learn how to use the camera for previews and taking pictures: https://docs.flutter.dev/cookbook/plugins/picture-using-camera
*/
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
    if (cameras.isNotEmpty) {
      var tempController = CameraController(
          cameras[0], ResolutionPreset.veryHigh,
          enableAudio: false);
      await tempController.initialize();
      setState(() {
        controller = tempController;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(controller!),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () async {
                    final photo = await controller!.takePicture();
                    controller!.pausePreview();
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ScanScreen(image: File(photo.path))));
                    controller!.resumePreview();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 6)),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
