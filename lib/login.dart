import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController(); // Controller for first name
  final _lastNameController = TextEditingController(); // Controller for last name
  String _errorMessage = '';
  bool _isRegister = false;  // Toggle between register and login

  void _registerAccount() async {
  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (userCredential.user != null) {
      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': _firstNameController.text.trim(), // Store first name
          'lastName': _lastNameController.text.trim(), // Store last name
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'friends': [], // Initialize empty array for friends
      });

      // Navigate to the main application screen after successful registration
      Navigator.pushReplacementNamed(context, '/mainApp');
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      _errorMessage = e.message ?? 'An error occurred. Please try again.';
    });
  }
}

  void _signInWithEmailAndPassword() async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // Navigate to the main application screen after successful login
        Navigator.pushReplacementNamed(context, '/mainApp');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegister ? 'Register' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRegister) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                  ),
                  SizedBox(width: 10),  // spacing between the text fields
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ],
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRegister ? _registerAccount : _signInWithEmailAndPassword,
              child: Text(_isRegister ? 'Register' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegister = !_isRegister;
                  _errorMessage = '';
                });
              },
              child: Text(_isRegister ? 'Already have an account? Login' : 'Need an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
