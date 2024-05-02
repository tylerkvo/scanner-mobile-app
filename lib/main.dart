import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanner/photo.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Permission.camera.request();
  _cameras = await availableCameras();
  runApp(MaterialApp(home: CameraApp()));
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  Future<void> pause() async {
    await Future.delayed(Duration(seconds: 10));
    controller.pausePreview();
    //final pic  = controller.takePicture();
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        print(e);
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    pause();
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
    return Scaffold(
        body: Column(
      //alignment: Alignment.bottomCenter,
      children: [
        Expanded(child: CameraPreview(controller)),
        //CameraPreview(controller),
        GestureDetector(
            onTap: () async {
              final photo = await controller.takePicture();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageDescription(
                          image: Image.file(File(photo.path)))));
            },
            child: Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Color.fromRGBO(255, 255, 255, 0.5), width: 5))))
      ],
    ));
  }
}
