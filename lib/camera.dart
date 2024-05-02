import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  CameraScreen({required this.cameras});

  @override
  Widget build(BuildContext context) {
    // You can use the cameras list here for your functionality
    return Scaffold(
      body: Center(
        child: Text('Camera Screen'),
      ),
    );
  }
}
