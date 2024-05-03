import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scanner/view.dart';  // Ensure you are using the correct import for ViewScreen

class DocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Scans', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: DocumentsGrid(),
    );
  }
}

class DocumentsGrid extends StatefulWidget {
  @override
  _DocumentsGridState createState() => _DocumentsGridState();
}

class _DocumentsGridState extends State<DocumentsGrid> {
  Stream<List<Map<String, dynamic>>> _scansStream() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots().map((snapshot) {
      var scans = List<Map<String, dynamic>>.from(snapshot.data()?['scans'] ?? []);
      return scans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _scansStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No scans found"));
        }

        var scans = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: scans.length,
          itemBuilder: (context, index) {
            var scan = scans[index];
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewScreen(
                        imageUrl: scan['url'],
                        scanContents: scan['text'],
                        documentId: scan['timestamp'].toString(),
                      )
                    )
                  ).then((_) => setState(() {})); // This ensures the grid updates after returning from the ViewScreen
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Image.network(scan['url'], fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateTime.fromMillisecondsSinceEpoch(scan['timestamp']).toString(), style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
