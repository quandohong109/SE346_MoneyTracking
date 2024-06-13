import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login/login_screen.dart';
import 'screens/login/signup_screen.dart'; // Assuming you have a SignUpScreen
import 'screens/login/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name:'money-tracking',
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCs_ezB9Gnzxfnpckvy6-drXyN0t6IDfpY',
          projectId: 'making-login',
          appId: '1:736101389040:android:cdfdf3e286376bce292835', messagingSenderId: '736101389040',
          // Add other Firebase options as needed
        ),
      );
    }
    runApp(const MyApp());
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Define named routes for navigation
      routes: {
        '/login': (context) => LoginScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/profile': (context) => ProfilePage(),
        // Add more routes for other screens
      },
      home: const HomeScreen(), // Display HomeScreen by default
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}