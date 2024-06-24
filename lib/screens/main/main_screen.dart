import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_tracking/screens/main/add_transaction/view/modify_transaction_screen.dart';
import 'package:money_tracking/screens/transaction/views/transaction_screen.dart';

import '../../data/firebase/firebase.dart';
import '../home/views/home_screen.dart';
import '../stat/views/stat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget Function()> widgetList = [
        () => const HomeScreen(),
        () => TransactionScreen.newInstance(),
        () => const StatScreen(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () async {
                await pushCategoryListToFirebase();
                await pushWalletListToFirebase();
                await pushTransactionListToFirebase();
              },
            ),
          ],
        ),
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
              currentIndex: index,
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
                    builder: (BuildContext context) => ModifyTransactionScreen.newInstance(),
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