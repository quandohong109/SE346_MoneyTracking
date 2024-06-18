import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfilePage({super.key});

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to your Profile Page!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              'Email: ${_auth.currentUser?.email ?? 'No email available'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                try {
                  await _auth.signOut();
                  // Navigate back to the login screen after logout
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}