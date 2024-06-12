import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

void main() {
  Firebase.initializeApp(
    options:const FirebaseOptions(
        apiKey: "AIzaSyDVcTj2WN5ZcDrSXb-hQztCM1EzdEnmLZM",
        authDomain: "money-tracking-se346.firebaseapp.com",
        projectId: "money-tracking-se346",
        storageBucket: "money-tracking-se346.appspot.com",
        messagingSenderId: "363617900262",
        appId: "1:363617900262:web:341b1b1c24724382020d27",
        measurementId: "G-7M100NZ5F7")
  );
  runApp(const MyApp());
}