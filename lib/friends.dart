import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> _allUsers = [];
  List<String> _friendIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUsers();
  }

    Future<void> _fetchUsers() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    List<dynamic> currentUserFriends = currentUserDoc['friends'];

    var querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> users = [];

    for (var doc in querySnapshot.docs) {
      if (doc.id != currentUserId) {
        Map<String, dynamic> user = {
          'id': doc.id,
          'username': doc['username'],
          'isFriend': currentUserFriends.contains(doc.id),
        };
        users.add(user);
      }
    }

    setState(() {
      _allUsers = users;
      _friendIds = List<String>.from(currentUserFriends);
      _isLoading = false;
    });
  }

  void _addFriend(String friendId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Add friend
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'friends': FieldValue.arrayUnion([friendId])
    });

    // Update local state
    int index = _allUsers.indexWhere((user) => user['id'] == friendId);
    if (index != -1) {
      setState(() {
        _allUsers[index]['isFriend'] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Add Friends'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: _allUsers.where((user) => user['isFriend']).map((user) {
                    return ListTile(
                      title: Text(user['username']),
                    );
                  }).toList(),
                ),
                ListView(
                  children: _allUsers.where((user) => !user['isFriend']).map((user) {
                    return ListTile(
                      title: Text(user['username']),
                      trailing: ElevatedButton(
                        onPressed: () => _addFriend(user['id']),
                        child: Text('Add'),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
