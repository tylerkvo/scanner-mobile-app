import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewScreen extends StatefulWidget {
  final String imageUrl;
  final String scanContents;
  final String documentId;  // Unique ID to identify the scan for deletion

  ViewScreen({super.key, required this.imageUrl, required this.scanContents, required this.documentId});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  Future<void> _deleteScan() async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

  // Get the current user document
  DocumentSnapshot userDoc = await userDocRef.get();
  if (userDoc.exists) {
    List<dynamic> scans = userDoc['scans'] ?? [];

    // Find and remove the scan with matching 'timestamp'
    int indexToRemove = scans.indexWhere((scan) => scan['timestamp'].toString() == widget.documentId);
    if (indexToRemove != -1) {
      scans.removeAt(indexToRemove);

      // Update the document with the new array
      await userDocRef.update({'scans': scans});
      Navigator.pop(context); // Go back to the documents screen after deleting
    } else {
      // Handle the case where the scan is not found
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan not found')));
    }
  } else {
    // Handle the case where the user document does not exist
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User document does not exist')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Scan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteScan,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Image.network(widget.imageUrl, fit: BoxFit.cover),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(widget.scanContents, style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
