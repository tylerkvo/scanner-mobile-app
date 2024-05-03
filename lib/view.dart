import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewScreen extends StatefulWidget {
  final String imageUrl;
  final String scanContents;
  final String documentId;

  ViewScreen(
      {super.key,
      required this.imageUrl,
      required this.scanContents,
      required this.documentId});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  Future<void> _deleteScan() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    DocumentSnapshot userDoc = await userDocRef.get();
    if (userDoc.exists) {
      var scans = userDoc['scans'] ?? [];
      int idx = scans.indexWhere(
          (scan) => scan['timestamp'].toString() == widget.documentId);
      if (idx != -1) {
        scans.removeAt(idx);
        await userDocRef.update({'scans': scans});
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("View Scan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: false,
            actions: [
              IconButton(icon: const Icon(Icons.delete), onPressed: _deleteScan)
            ]),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                padding: const EdgeInsets.all(8),
                child: Image.network(widget.imageUrl, fit: BoxFit.contain)),
            Container(
                padding: const EdgeInsets.all(8),
                child: Text(widget.scanContents,
                    style: const TextStyle(fontSize: 16)))
          ]),
        ));
  }
}
