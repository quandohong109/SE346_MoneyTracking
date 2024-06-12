import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

import 'screens/login/login_screen.dart';
import 'screens/login/signup_screen.dart'; // Assuming you have a SignUpScreen
import 'screens/login/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCs_ezB9Gnzxfnpckvy6-drXyN0t6IDfpY',
        projectId: 'making-login',
        appId: '1:736101389040:android:cdfdf3e286376bce292835', messagingSenderId: '736101389040',
        // Add other Firebase options as needed
      ),
    );
    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
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
        '/sign-up': (context) => SignUpScreen(),
        '/profile': (context) => ProfilePage(),
        // Add more routes for other screens
      },
      home: HomeScreen(), // Display HomeScreen by default
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// void main() {
//   Firebase.initializeApp(
//     options:const FirebaseOptions(
//         apiKey: "AIzaSyDVcTj2WN5ZcDrSXb-hQztCM1EzdEnmLZM",
//         authDomain: "money-tracking-se346.firebaseapp.com",
//         projectId: "money-tracking-se346",
//         storageBucket: "money-tracking-se346.appspot.com",
//         messagingSenderId: "363617900262",
//         appId: "1:363617900262:web:341b1b1c24724382020d27",
//         measurementId: "G-7M100NZ5F7")
//   );
//   runApp(const MyApp());
// }