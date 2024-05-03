import 'dart:io';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: Scaffold(body: ScanScreen(image: File("path_to_your_image.jpeg")))));
}

class ScanScreen extends StatelessWidget {
  final File image;
  final String scannedText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."; // Placeholder for scanned text

  const ScanScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Untitled photo", style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2, // Takes 2/3 of the screen space
            child: Container(
              margin: const EdgeInsets.all(14),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 4)],
              ),
              child: Image(image: FileImage(image), fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 1, // Takes 1/3 of the screen space
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Text(
                scannedText,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(height: 70, child: 
      BottomAppBar(
        color: Colors.black,  // This is the color of the BottomAppBar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,  // Aligns the button to the right
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,  // Background color of the button
                borderRadius: BorderRadius.circular(30),  // Makes it oval
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save Tapped')));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,  // Minimizes the Row size to fit its children
                  children: [
                    Text("Save", style: TextStyle(color: Colors.white)),  // Save text
                    SizedBox(width: 10),
                    Icon(Icons.save, color: Colors.white),  // Save icon
                    
                    
                  ],
                ),
              ),
            ),
        
          ],
        ),
      ),
      )
    );
  }
}
