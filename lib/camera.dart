import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:scanner/scan.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}
class NoAnimationPageRoute extends PageRouteBuilder {
  final Widget page;

  NoAnimationPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return child; // No animation
          },
        );
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller; // Make it nullable

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      var tempController = CameraController(cameras[0], ResolutionPreset.veryHigh, enableAudio: false);
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
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    final photo = await controller!.takePicture();
                    controller!.pausePreview();
                    await Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        page: ScanScreen(image: File(photo.path))
                      )
                    );
                    controller!.resumePreview();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 6)
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
