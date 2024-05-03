import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanScreen extends StatefulWidget {
  final File image;
  String? scanContents;

  ScanScreen({super.key, required this.image, this.scanContents});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Future<void> _fetchScanContents() async {
    final imageData = base64Encode(await widget.image.readAsBytes());
    final resp = await http.post(
      Uri.parse(
          'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyDHALPXcvTJE1CIZB8XJY-aFhrZSalffbk'),
      body: jsonEncode({
        "requests": [
          {
            "image": {"content": imageData},
            "features": [
              {"type": "TEXT_DETECTION"}
            ]
          }
        ]
      }),
    );
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      final textData = json['responses'][0]['fullTextAnnotation'];
      setState(() {
        widget.scanContents =
            textData != null ? textData['text'] : "No text detected";
      });
    }
  }

  Future<void> _saveScan() async {
  // Get current time as a timestamp to create a unique file name
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  // Create a reference to Firebase Storage
  final storageRef = FirebaseStorage.instance.ref('scans/$timestamp.jpg');

  // Upload the file
  await storageRef.putFile(widget.image);

  // Get the download URL
  final String url = await storageRef.getDownloadURL();

  // Get the current user ID
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Prepare the scan data
  Map<String, dynamic> scanData = {
    'timestamp': timestamp,
    'url': url,
    'text': widget.scanContents ?? "No text detected", // Use default text if none detected
  };

  // Update the user's document in Firestore
  await FirebaseFirestore.instance.collection('users').doc(currentUserId)
    .update({
      'scans': FieldValue.arrayUnion([scanData]), // Adds scan data to an array of scans
    });
  Navigator.pop(context);
  // Show a snackbar message
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scan saved')));
}


  @override
  void initState() {
    super.initState();
    if (widget.scanContents == null) {
      _fetchScanContents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Results",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
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
                            color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 4)
                      ]),
                  child: Image.file(widget.image, fit: BoxFit.contain)))),
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
          child: SingleChildScrollView(
              child: widget.scanContents != null
                  ? Text(widget.scanContents!)
                  : const Center(child: CircularProgressIndicator()))),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: widget.scanContents != null
            ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FilledButton.icon(
                    onPressed: () async {
                      await _saveScan();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Scan saved')));
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save'))
              ])
            : null,
      ),
    );
  }
}
