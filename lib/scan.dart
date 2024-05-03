import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  final File image;
  String? scanContents;

  ScanScreen({super.key, required this.image, this.scanContents});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Future<void> _fetchScanContents() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      widget.scanContents =
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vel facilisis volutpat est velit egestas. Bibendum enim facilisis gravida neque convallis a. Elit at imperdiet dui accumsan sit amet nulla facilisi. Mauris pellentesque pulvinar pellentesque habitant morbi tristique senectus. Ullamcorper sit amet risus nullam eget. Posuere morbi leo urna molestie at elementum eu. In fermentum et sollicitudin ac. Feugiat sed lectus vestibulum mattis ullamcorper. Nulla aliquet porttitor lacus luctus accumsan. Nulla aliquet porttitor lacus luctus. Ac tincidunt vitae semper quis lectus. A diam maecenas sed enim ut sem viverra aliquet eget. In vitae turpis massa sed elementum tempus egestas sed sed. Etiam dignissim diam quis enim lobortis scelerisque. Velit dignissim sodales ut eu. Sed vulputate odio ut enim blandit volutpat. Nec ullamcorper sit amet risus nullam eget felis eget. Dictumst quisque sagittis purus sit. Elit ut aliquam purus sit amet luctus venenatis lectus. Suscipit adipiscing bibendum est ultricies integer.";
    });
    return;
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
    print(resp.body);
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
      //   title: const Text("Untitled photo", style: TextStyle(fontWeight: FontWeight.bold)),
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //     icon: const Icon(Icons.close),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      // body: Column(
      //   children: [
      //     Expanded(
      //       flex: 2, // Takes 2/3 of the screen space
      //       child: Container(
      //         margin: const EdgeInsets.all(14),
      //         alignment: Alignment.center,
      //         decoration: const BoxDecoration(
      //           boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 4)],
      //         ),
      //         child: Image(image: FileImage(image), fit: BoxFit.contain),
      //       ),
      //     ),
      //     Expanded(
      //       flex: 1, // Takes 1/3 of the screen space
      //       child: SingleChildScrollView(
      //         padding: const EdgeInsets.all(14),
      //         child: Text(
      //           scannedText,
      //           style: TextStyle(fontSize: 16, color: Colors.black),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
      // bottomNavigationBar: SizedBox(height: 70, child: 
      // BottomAppBar(
      //   color: Colors.black,  // This is the color of the BottomAppBar
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,  // Aligns the button to the right
      //     children: <Widget>[
      //       Container(
      //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //         decoration: BoxDecoration(
      //           color: Colors.blue,  // Background color of the button
      //           borderRadius: BorderRadius.circular(30),  // Makes it oval
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black26,
      //               blurRadius: 4,
      //               offset: Offset(0, 2),
      //             )
      //           ],
      //         ),
      //         child: InkWell(
      //           onTap: () {
      //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save Tapped')));
      //           },
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,  // Minimizes the Row size to fit its children
      //             children: [
      //               Text("Save", style: TextStyle(color: Colors.white)),  // Save text
      //               SizedBox(width: 10),
      //               Icon(Icons.save, color: Colors.white),  // Save icon
                    
                    
      //             ],
      //           ),
      //         ),
      //       ),
        
      //     ],
      //   ),
      // ),
      // )
    );
  }
}