import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_tracking/data/firebase/firebase.dart';

import '../../functions/getdata.dart';
import '../../objects/models/wallet_model.dart';
import '../database/database.dart';

class WalletBUS {
  static bool changeBalance(BigInt amount, int walletID) {
    return Firebase().walletList.where((e) => e.id == walletID).first.changeBalance(amount);
  }

  static Future<bool> changeBalanceOnFirestore(BigInt amount, int walletID) async { // ID inside each Firestore wallet's collection
    final firestoreInstance = FirebaseFirestore.instance;
    final walletQuery = firestoreInstance.collection('wallets').where('id', isEqualTo: walletID);

    return walletQuery.get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var walletDoc = querySnapshot.docs.first;
        BigInt currentBalance = BigInt.parse(walletDoc.data()['balance']);
        BigInt newBalance = currentBalance + amount;

        return walletDoc.reference.update({'balance': newBalance.toString()}).then((_) {
          return true;
        }).catchError((error) {
          print("Failed to update wallet: $error");
          return false;
        });
      } else {
        print("No wallet found with id: $walletID");
        return false;
      }
    });
  }

  // static Future<bool> changeBalanceOnFirestore(BigInt amount, int walletID) async { // ID is wallet's document ID
  //   final firestoreInstance = FirebaseFirestore.instance;
  //   final walletRef = firestoreInstance.collection('wallets').doc(walletID.toString());
  //
  //   return walletRef.get().then((docSnapshot) {
  //     if (docSnapshot.exists) {
  //       BigInt currentBalance = BigInt.parse(docSnapshot.data()?['balance']);
  //       BigInt newBalance = currentBalance + amount;
  //
  //       return walletRef.update({'balance': newBalance.toString()}).then((_) {
  //         return true;
  //       }).catchError((error) {
  //         print("Failed to update wallet: $error");
  //         return false;
  //       });
  //     } else {
  //       print("No wallet found with id: $walletID");
  //       return false;
  //     }
  //   });
  // }

  static Future<void> addWalletToFirestore(WalletModel wallet) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('wallets').orderBy('id', descending: true).limit(1).get();
      var data = snapshot.docs.first.data();
      int maxId = data['id'];
      int newId = maxId + 1;

      // Now use newId for the new wallet
      await FirebaseFirestore.instance.collection('wallets').add({
        'id': newId,
        'name': wallet.name,
        'balance': wallet.balance.toString(),
        'userID': GetData.getUID(),
      });

      // Show success toast
      // Fluttertoast.showToast(
      //     msg: "Wallet added successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );

      await Database().updateWalletListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<void> deleteWalletFromFirestore(int walletId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('id', isEqualTo: walletId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      Fluttertoast.showToast(
          msg: "Wallet deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      await Database().updateWalletListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }
}