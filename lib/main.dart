import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera.dart'; 
import 'friends.dart'; 
import 'documents.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final cameras = await availableCameras();
  runApp(MaterialApp(home: MainApp(cameras: cameras)));
}

class MainApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  MainApp({required this.cameras});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1; // Set this to 1 to open Camera screen first

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get widgetOptions => <Widget>[
    DocumentsScreen(),  // First in the list, but on the left in the navigation
    CameraScreen(cameras: widget.cameras),  // Second in the list, but in the center
    FriendsScreen(),  // Third in the list, but on the right
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
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
