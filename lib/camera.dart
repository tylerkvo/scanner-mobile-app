import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:scanner/document.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller; // Make it nullable

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      var tempController = CameraController(cameras[0], ResolutionPreset.veryHigh);
      await tempController.initialize().then((_) {
        if (!mounted) return;
        setState(() => controller = tempController);
      }).catchError((Object e) {
        if (e is CameraException) {
          print('Camera initialization error: ${e.description}');
        }
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
    controller?.dispose(); // Dispose safely
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if controller is initialized
    if (controller == null || !controller!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(), // Show loading indicator
      );
    }

    return Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(child: CameraPreview(controller!)), // Use the controller safely
            GestureDetector(
              onTap: () async {
                final photo = await controller!.takePicture();
                controller!.pausePreview();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentScreen(image: File(photo.path))
                  )
                );
                controller!.resumePreview();
              },
              child: Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(155, 155, 155, 0.3),
                    width: 5
                  )
                )
              )
            )
          ],
        )
    );
  }
}
