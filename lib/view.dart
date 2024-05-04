import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewScreen extends StatefulWidget {
  final String imageUrl;
  final String scanContents;
  final String documentId;
  final bool isFriend;

  ViewScreen(
      {super.key,
      required this.imageUrl,
      required this.scanContents,
      required this.documentId,
      this.isFriend = false});

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
            actions: !widget.isFriend
                ? [
                    IconButton(
                        icon: const Icon(Icons.delete), onPressed: _deleteScan)
                  ]
                : null),
        body: LayoutBuilder(
            builder: (context, constraints) => Container(
                height: constraints.maxHeight - 320,
                margin: const EdgeInsets.all(14),
                alignment: Alignment.center,
                child: Container(
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 4)
                    ]),
                    child:
                        Image.network(widget.imageUrl, fit: BoxFit.contain)))),
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
            child: SingleChildScrollView(child: Text(widget.scanContents))));
  }
}
