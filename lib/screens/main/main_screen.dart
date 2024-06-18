import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_tracking/screens/main/add_expense/view/add_screen.dart';
import 'package:money_tracking/screens/transaction/views/transaction_screen.dart';

import '../home/views/home_screen.dart';
import '../stat/views/stat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget Function()> widgetList = [
        () => const HomeScreen(),
        () => TransactionScreen.newInstance(),
        () => const StatScreen(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30)
          ),
          child: BottomNavigationBar(
              onTap: (value) {
                if (value != index) {
                  setState(() {
                    index = value;
                  });
                }
              },
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 3,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.currency_exchange),
                    label: "Transaction"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: "Stats"
                )
              ]
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddScreen.newInstance(),
                  )
              );
            },
            shape: const CircleBorder(),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  )
              ),
              child: const Icon(
                  Icons.add
              ),
            )
        ),
        body: widgetList[index]()

    );
  }
}
