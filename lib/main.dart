/*
Used BottomNavigationBar docs: https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
*/
import 'package:flutter/material.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/mainApp': (context) => MainApp(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1;

  final screens = [DocumentsScreen(), CameraScreen(), FriendsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 0 ? Icons.folder : Icons.folder_outlined),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? Icons.camera_alt
                : Icons.camera_alt_outlined),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 2 ? Icons.people : Icons.people_outline),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: _selectedIndex == 1 ? Colors.black : Colors.white,
        unselectedItemColor: _selectedIndex == 1 ? Colors.white : Colors.black,
        selectedItemColor: _selectedIndex == 1 ? Colors.white : Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 36,
      ),
    );
  }
}
