import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart'; // Add this package for user avatar
import 'package:money_tracking/functions/custom_dialog.dart';
import 'package:money_tracking/screens/login/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../main.dart';
import 'changeusername.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<Map<String, dynamic>?> _getUserInfo() async {
    if (_auth.currentUser != null) {
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();

      await _auth.sendPasswordResetEmail(email: email);

      CustomDialog.showInfoDialog(context, "Password Reset", "Password reset email sent to $email");
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> _updateUserName(String newName) async {
    if (_auth.currentUser != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
              'name': newName,
            });
        CustomDialog.showInfoDialog(context, "Update Name", "Name updated to $newName");
        setState(() {
          _nameController.text = newName;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error updating name: $e');
        }
        CustomDialog.showInfoDialog(context, "Error", "Error updating name: $e");
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
            _emailController.text = email ?? '';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // User avatar
                  ProfilePicture(
                    name: name ?? 'User',
                    radius: 50,
                    fontsize: 40,
                  ),
                  const SizedBox(height: 20),
                  // User name
                  Text(
                    name ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // User email
                  Text(
                    'Email: ${email ?? 'No email available'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  // Change username button
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('CHANGE USERNAME'),
                            content: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Username',
                                hintText: 'Enter new username...',
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                ),
                                onPressed: () async {
                                  final newName = _nameController.text.trim();
                                  if (newName.isNotEmpty) {
                                    await _updateUserName(newName);
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter a valid name')),
                                    );
                                  }
                                },
                                child: const Text('Update', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      side: const BorderSide(
                          color: Colors.blue), // Border color when button is enabled
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit, // Change username icon
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          'Change your username',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Change password button
                  OutlinedButton(
                    onPressed: () => _sendPasswordResetEmail(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      side: const BorderSide(
                          color: Colors.blue), // Border color when button is enabled
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_open, // Change password icon
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          'Change your password',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () async {
                      // Sign out the user
                      try {
                        await _auth.signOut();
                        // Navigate back to the home screen after logout
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        if (kDebugMode) {
                          print('Error signing out: $e');
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      side: const BorderSide(
                          color: Colors.red), // Border color when button is enabled
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout, // Logout icon
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Text color
                          ),
                        ),
                      ],
                    ),
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