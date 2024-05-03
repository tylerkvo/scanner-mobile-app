import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:scanner/document.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller; // Make it nullable

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      var tempController = CameraController(cameras[0], ResolutionPreset.veryHigh, enableAudio: false); // Disable audio if not needed
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    // Set status bar color to black with white icons
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: SafeArea( // Ensure content does not overlap the status bar
        child: Stack(
          fit: StackFit.expand, // Ensures the stack fills the whole space
          children: [
            CameraPreview(controller!), // This will now respect SafeArea boundaries
            Positioned(
              bottom: 50, // Distance from bottom
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 6
                      )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
