/*
Used Flutter GridBuilder examples to learn how to show images in a grid: https://api.flutter.dev/flutter/widgets/GridView-class.html#widgets.GridView.5
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner/view.dart';

class MyDocumentsScreen extends StatelessWidget {
  MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Scans',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: DocumentsGrid(uid: FirebaseAuth.instance.currentUser!.uid),
    );
  }
}

class FriendDocumentsScreen extends StatelessWidget {
  String uid;
  String firstName;

  FriendDocumentsScreen({required this.uid, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$firstName\'s Scans',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: DocumentsGrid(uid: uid, isFriend: true),
    );
  }
}

class DocumentsGrid extends StatefulWidget {
  String uid;
  bool isFriend;

  DocumentsGrid({required this.uid, this.isFriend = false});

  @override
  State<DocumentsGrid> createState() => _DocumentsGridState();
}

class _DocumentsGridState extends State<DocumentsGrid> {
  List<Map<String, dynamic>>? scans;

  Future<void> _fetchScans() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    setState(() {
      scans = List<Map<String, dynamic>>.from(userData['scans'] ?? []);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchScans();
  }

  @override
  Widget build(BuildContext context) {
    if (scans == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (scans!.isEmpty) {
      return const Center(child: Text("No scans found"));
    }

    return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: scans!.length,
        itemBuilder: (context, index) {
          var scan = scans![index];
          return Card(
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewScreen(
                            imageUrl: scan['url'],
                            scanContents: scan['text'],
                            documentId: scan['timestamp'].toString(),
                            isFriend: widget.isFriend)));
                setState(() {
                  _fetchScans();
                });
              },
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(children: [
                    Expanded(
                      child: Image.network(scan['url'], fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          DateTime.fromMillisecondsSinceEpoch(scan['timestamp'])
                              .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    )
                  ])),
            ),
          );
        });
  }
}
