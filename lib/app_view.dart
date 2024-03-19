import 'package:flutter/material.dart';

import 'screens/main/main_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quan Ly Chi Tieu",
      theme: ThemeData(
          colorScheme: ColorScheme.light(
              background: Colors.grey.shade100,
              onBackground: Colors.black,
              primary: const Color(0xFF03D2F0),
              secondary: const Color(0xFF3CEDF7),
              tertiary: const Color(0xFFB2EBF2)
          )
      ),
      home: const MainScreen(),
    );
  }
}