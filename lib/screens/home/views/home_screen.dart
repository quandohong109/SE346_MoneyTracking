import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<String?> _getUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc['name'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false, // This removes the back arrow
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.cyanAccent.shade400,
                                  ),
                                ),
                                Icon(
                                  Icons.person_2_rounded,
                                  color: Colors.cyanAccent.shade700,
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome!",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  name ?? 'User',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        transform: const GradientRotation(pi / 4),
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
