import 'dart:io';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
      //theme: ThemeData(bottomSheetTheme: BottomSheetThemeData(elevation: 0)),
      home: Scaffold(body: DocumentScreen(image: File("assets/logo.jpeg")))));
}

class DocumentScreen extends StatelessWidget {
  final File image;

  const DocumentScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
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
        body: LayoutBuilder(
            builder: (context, constraints) => Container(
                height: constraints.maxHeight - 320,
                margin: const EdgeInsets.all(14),
                alignment: Alignment.center,
                child: Container(
                    decoration: const BoxDecoration(
                        //border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1))),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 4)
                        ]),
                    child:
                        Image(image: FileImage(image), fit: BoxFit.contain)))),
        bottomSheet: Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular((24))),
            boxShadow: [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.15), blurRadius: 6)
            ],
          ),
          child: const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec et odio pellentesque diam. Ipsum a arcu cursus vitae congue mauris rhoncus aenean vel. Consectetur purus ut faucibus pulvinar elementum integer enim. Dictum at tempor commodo ullamcorper a lacus. Lectus nulla at volutpat diam ut venenatis tellus in. Proin sed libero enim sed faucibus. Arcu risus quis varius quam quisque. Ultricies lacus sed turpis tincidunt. Vel orci porta non pulvinar."),
        ));
  }
}
