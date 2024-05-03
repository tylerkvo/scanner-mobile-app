import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DocumentScreen extends StatefulWidget {
  final File image;
  String? scanContents;

  DocumentScreen({super.key, required this.image, this.scanContents});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
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
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Scan saved')));
              },
              child: const Text("Save"),
            )
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
                            color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 4)
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
    );
  }
}
