import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera.dart'; // Assuming you have this file for camera functionality
import 'friends.dart'; // Assuming you have this file for friends functionality
import 'documents.dart'; // Assuming you have this file for documents functionality

void main() {
  runApp(MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1; // Set this to 1 to open Camera screen first
  List<CameraDescription> cameras = [];
  bool _cameraInit = false;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    setState(() {
      _cameraInit = true;
    });
  }

  final List<Widget> Function(List<CameraDescription>) _widgetOptions = 
      (cameras) => <Widget>[
    DocumentsScreen(),  // First in the list, but on the left in the navigation
    CameraScreen(cameras: cameras),  // Second in the list, but in the center
    FriendsScreen(),  // Third in the list, but on the right
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if cameras are initialized
    if (!_cameraInit) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions(cameras).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
