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
  int _selectedIndex = 1; // Set this to 1 to open Camera screen first

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder, color: Colors.white), // Set icon color to white
            label: 'Documents', // Set label to empty string to remove it
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt, color: Colors.white), // Set icon color to white
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Colors.white), // Set icon color to white
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black, // Set background color to black
        unselectedItemColor: Colors.white, // Set unselected item color to white
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        showSelectedLabels: false, // Hide selected labels
        showUnselectedLabels: false, // Hide unselected labels
        iconSize: 36,
      ),
    );
  }
}
