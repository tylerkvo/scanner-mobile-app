import 'package:flutter/material.dart';

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
class DocumentsGrid extends StatelessWidget {
  final List<String> documents = [
    "Notes",
    "Document",
    "Exam",
    "Translate",
    "Bills",
    // Add more documents as needed
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns
        crossAxisSpacing: 5, // Horizontal space between tiles
        mainAxisSpacing: 5, // Vertical space between tiles
        childAspectRatio: 1 / 1.2, // Aspect ratio of each tile
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically
            mainAxisSize: MainAxisSize.min, // Reduce the space to a minimum
            children: <Widget>[
              Icon(Icons.description, size: 50, color: Colors.blue), // Paper icon
              Text(documents[index], textAlign: TextAlign.center), // Document title
            ],
          ),
        );
      },
    );
  }
}