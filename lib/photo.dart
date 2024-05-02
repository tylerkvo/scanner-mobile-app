import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      //theme: ThemeData(bottomSheetTheme: BottomSheetThemeData(elevation: 0)),
      home: Scaffold(
          body: ImageDescription(
              image: Image(image: AssetImage("assets/logo.jpeg"))))));
}

class ImageDescription extends StatelessWidget {
  const ImageDescription({super.key, required this.image});

  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
      onDestinationSelected: (int index) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return Scaffold(
                appBar: AppBar(
                    title: const Text("Untitled photo",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    centerTitle: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Title modified')));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]),
                body: Container(
                  child: image,
                  margin: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      //border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1))),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 4)
                      ]),
                ),
                bottomSheet: Container(
                  height: 300,
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular((24))),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 6)
                    ],
                  ),
                  child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec et odio pellentesque diam. Ipsum a arcu cursus vitae congue mauris rhoncus aenean vel. Consectetur purus ut faucibus pulvinar elementum integer enim. Dictum at tempor commodo ullamcorper a lacus. Lectus nulla at volutpat diam ut venenatis tellus in. Proin sed libero enim sed faucibus. Arcu risus quis varius quam quisque. Ultricies lacus sed turpis tincidunt. Vel orci porta non pulvinar."),
                ));
          },
        ));
      },
      //selectedIndex: currentPageIndex,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.notifications_sharp)),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.people),
          label: 'Friends',
        ),
      ],
    ));
  }
}
