import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../main.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfilePage({super.key});

  Future<String?> _getUserName() async {
    if (_auth.currentUser != null) {
      final DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      return userDoc['name'];
    }
    return null;
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
        child: FutureBuilder<String?>(
          future: _getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Text('Error loading user name');
            }
            final String? name = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to your Profile Page!',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'Name: ${name ?? 'No name available'}',
                  style: const TextStyle(fontSize: 16),
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
            );
          },
        ),
      ),
    );
  }
}
