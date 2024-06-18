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

  static void addWalletToFirestore(WalletModel wallet) {
    FirebaseFirestore.instance.collection('wallets').orderBy('id', descending: true).limit(1).get().then((snapshot) {
      int maxId = snapshot.docs.first.data()['id'];
      int newId = maxId + 1;

      // Now use newId for the new wallet
      FirebaseFirestore.instance.collection('wallets').add({
        'id': newId,
        'name': wallet.name,
        'iconID': wallet.icon.id,
        'balance': wallet.balance.toString(),
        'userID': GetData.getUID(),
      }).then((_) {
        // Show success toast
        Fluttertoast.showToast(
            msg: "Wallet added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
      Database().updateWalletListFromFirestore();
    });
  }

  static void deleteWalletFromFirestore(int walletId) {
    FirebaseFirestore.instance.collection('wallets')
        .where('id', isEqualTo: walletId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).then((_) {
      // FirebaseFirestore.instance.collection('wallets').doc(walletId).delete().then((_) { // ID is wallet's document ID
      Fluttertoast.showToast(
          msg: "Wallet deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
    Database().updateWalletListFromFirestore();
  }
}