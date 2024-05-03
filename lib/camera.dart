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
  late CameraController controller;

  Future<void> pause() async {
    await Future.delayed(Duration(seconds: 10));
    controller.pausePreview();
    //final pic  = controller.takePicture();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.veryHigh);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        print(e);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setupCamera();
    //pause();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Container(
        color: Colors.black,
        child: Column(
          //alignment: Alignment.bottomCenter,
          children: [
            Expanded(child: CameraPreview(controller)),
            //CameraPreview(controller),
            GestureDetector(
                onTap: () async {
                  final photo = await controller.takePicture();
                  controller.pausePreview();
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DocumentScreen(image: File(photo.path))));
                  controller.resumePreview();
                },
                child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color.fromRGBO(155, 155, 155, 0.3),
                            width: 5))))
          ],
        ));
  }
}
