import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera.dart'; 
import 'friends.dart'; 
import 'documents.dart'; 
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/mainApp': (context) => MainApp(cameras: cameras),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  MainApp({required this.cameras});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1; // Open Camera screen first

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get widgetOptions => <Widget>[
        DocumentsScreen(), // First in the list, but on the left in the navigation
        CameraScreen(), // Second in the list, but in the center
        FriendsScreen(), // Third in the list, but on the right
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.folder : Icons.folder_outlined),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.camera_alt : Icons.camera_alt_outlined),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? Icons.people : Icons.people_outline),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: _selectedIndex == 1 ? Colors.black : Colors.white,
        unselectedItemColor: _selectedIndex == 1 ? Colors.white : Colors.black,
        selectedItemColor: _selectedIndex == 1 ? Colors.white : Colors.black,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 36,
      ),
    );
  }
}