/*
Used TabBar documentation: https://api.flutter.dev/flutter/material/TabBar-class.html
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scanner/documents.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late List<Map<String, dynamic>> _allUsers = [];
  //List<String> _friendIds = [];
  bool _isLoading = true;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchCurrentUserName();
  }

  Future<void> _fetchUsers() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    final currentUserFriends = currentUserDoc['friends'];

    var querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> users = [];
    for (var doc in querySnapshot.docs) {
      if (doc.id != currentUserId) {
        final user = {
          'id': doc.id,
          'firstName': doc['firstName'],
          'lastName': doc['lastName'],
          'username': doc['username'],
          'isFriend': currentUserFriends.contains(doc.id),
        };
        users.add(user);
      }
    }

    setState(() {
      _allUsers = users;
      //_friendIds = List<String>.from(currentUserFriends);
      _isLoading = false;
    });
  }

  Future<void> _fetchCurrentUserName() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _username = userData['username'] ?? 'No username';
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _addFriend(String friendId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update({
      'friends': FieldValue.arrayUnion([friendId])
    });

    int index = _allUsers.indexWhere((user) => user['id'] == friendId);
    if (index != -1) {
      setState(() {
        _allUsers[index]['isFriend'] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 1,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            actions: [
              IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await _logout();
                  }),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Friends'),
                Tab(text: 'Add Friends'),
              ],
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    ListView(
                      children: _allUsers
                          .where((user) => user['isFriend'])
                          .map((user) {
                        String initials =
                            (user['firstName'][0] + user['lastName'][0])
                                .toUpperCase();
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(initials),
                          ),
                          title: Text(
                              '${user['firstName']} ${user['lastName']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text(user['username']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FriendDocumentsScreen(
                                      uid: user['id'],
                                      firstName: user['firstName']),
                                ));
                          },
                        );
                      }).toList(),
                    ),
                    ListView(
                      children: _allUsers
                          .where((user) => !user['isFriend'])
                          .map((user) {
                        String initials =
                            (user['firstName'][0] + user['lastName'][0])
                                .toUpperCase();
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(initials),
                          ),
                          title: Text(
                              '${user['firstName']} ${user['lastName']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          subtitle: Text(user['username']),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _addFriend(user['id']);
                            },
                            child: const Text('Add'),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ));
  }
}
