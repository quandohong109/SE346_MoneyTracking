import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/database/database.dart';
import 'screens/login/login_screen.dart';
import 'screens/login/signup_screen.dart'; // Assuming you have a SignUpScreen
import 'screens/home/views/profile_screen.dart';
import 'screens/main/main_screen.dart'; // Import your MainScreen
import 'screens/home/views/home_screen.dart'; // Import your HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      name: 'money-tracking',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDVcTj2WN5ZcDrSXb-hQztCM1EzdEnmLZM',
        projectId: 'money-tracking-se346',
        appId: '1:363617900262:android:526d6402b059bd51020d27',
        messagingSenderId: '363617900262',
        // Add other Firebase options as needed
      ),
    );
    Database().updateCategoryListFromFirestore();
    // Database().updateWalletListFromFirestore();
    Database().updateWalletList();
    Database().updateTransactionListFromFirestore();
    runApp(const MyApp());
  } catch (e) {
    if (kDebugMode) {
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing Firebase: $e'),
          ),
        ),
      ));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracking',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: const ColorScheme.light(
            background: Color(0xFFF6F6F6),
            onBackground: Colors.black,
            primary: Color(0xFF0A98FF),
            secondary: Color(0xFFC15BFF),
            tertiary: Color(0xFFFBFF2B),
          )
      ),
      // Define named routes for navigation
      routes: {
        '/login': (context) => LoginScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/profile': (context) => ProfilePage(),
        '/main': (context) => const MainScreen(), // Add the MainScreen route
        '/home': (context) => const HomeScreen(),
        // Add more routes for other screens
      },
      home: const AuthWrapper(), // Use AuthWrapper as the home screen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const MainScreen(); // User is logged in, go to MainScreen
        }
        return const HomeScreen(); // User is not logged in, go to HomeScreen
      },
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
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/sign-up');
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
              child: const Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
