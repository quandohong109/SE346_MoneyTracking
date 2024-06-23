import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();

  Future<Map<String, dynamic>?> _getUserInfo() async {
    if (_auth.currentUser != null) {
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> _updateUserName(String newName) async {
    if (_auth.currentUser != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          'name': newName,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully')),
        );
        setState(() {
          _nameController.text = newName;
        });
      } catch (e) {
        print('Error updating name: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update name')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (_auth.currentUser == null) {
      // User is not logged in, navigate to the login screen
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Container(); // Return an empty container while navigating
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text('Error loading user information');
            }
            final userInfo = snapshot.data;
            final String? name = userInfo?['name'];
            final String? email = _auth.currentUser?.email;

            _nameController.text = name ?? '';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to your Profile Page!',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Email: ${email ?? 'No email available'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final newName = _nameController.text.trim();
                      if (newName.isNotEmpty) {
                        await _updateUserName(newName);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid name')),
                        );
                      }
                    },
                    child: const Text('Update Name'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Sign out the user
                      try {
                        await _auth.signOut();
                        // Navigate back to the home screen after logout
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        print('Error signing out: $e');
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
