import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/data/firebase/firebase.dart';
import 'package:money_tracking/functions/custom_exception.dart';

import '../../functions/custom_dialog.dart';
import '../../functions/getdata.dart';
import '../../objects/dtos/wallet_dto.dart';
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

  static Future<void> addWalletToFirestore(String walletName, String balance, BuildContext context) async {
    try {
      // Check if a wallet with the same name already exists
      var nameSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('name', isEqualTo: walletName)
          .get();

      if (nameSnapshot.docs.isNotEmpty) {
        // If a wallet with the same name exists, do not add the new wallet
        CustomDialog.showInfoDialog(context, 'Error', 'A wallet with the same name already exists.');
        return;
      } else {
        // If no wallet with the same name exists, add the new wallet
        var idSnapshot = await FirebaseFirestore.instance.collection('wallets').orderBy('id', descending: true).limit(1).get();
        var data = idSnapshot.docs.first.data();
        int maxId = data['id'];
        int newId = maxId + 1;

        await FirebaseFirestore.instance.collection('wallets').add({
          'id': newId,
          'name': walletName,
          'balance': balance,
          'userID': GetData.getUID(),
        });
        await Database().updateWalletListFromFirestore();
      }
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<bool> deleteWalletFromFirestore(int walletId, BuildContext context) async {
    try {
      // Check if there are any transactions associated with the wallet
      var transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('walletID', isEqualTo: walletId)
          .get();

      if (transactionSnapshot.docs.isNotEmpty) {
        // If there are transactions, show an AlertDialog and do not delete the wallet
        return false;
      } else {
        // If there are no transactions, delete the wallet and show an AlertDialog
        var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
            .where('id', isEqualTo: walletId)
            .get();
        for (var doc in walletSnapshot.docs) {
          await doc.reference.delete();
        }
        await Database().updateWalletListFromFirestore();
        return true;
      }
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<void> increaseWalletBalanceOnFirestore(int walletId, BigInt transactionValue) async {
    try {
      var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('id', isEqualTo: walletId)
          .get();
      for (var doc in walletSnapshot.docs) {
        BigInt currentBalance = BigInt.parse(doc.data()['balance']);
        BigInt newBalance = currentBalance + transactionValue;
        await doc.reference.update({
          'balance': newBalance.toString(),
        });
      }
      await Database().updateWalletListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<bool> decreaseWalletBalanceOnFirestore(int walletId, BigInt transactionValue) async {
    try {
      var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('id', isEqualTo: walletId)
          .get();
      for (var doc in walletSnapshot.docs) {
        BigInt currentBalance = BigInt.parse(doc.data()['balance']);
        if (transactionValue > currentBalance) {
          return false;
          // If the transaction value is greater than the current balance, do not decrease the balance
        } else {
          BigInt newBalance = currentBalance - transactionValue;

          // Get the total value of transactions using the wallet
          var transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
              .where('walletID', isEqualTo: walletId)
              .get();
          BigInt totalTransactionValue = BigInt.zero;
          for (var transactionDoc in transactionSnapshot.docs) {
            totalTransactionValue += BigInt.parse(transactionDoc.data()['value']);
          }

          // If the new balance is less than the total transaction value, do not decrease the balance
          if (newBalance < totalTransactionValue) {
            return false;
          }

          await doc.reference.update({
            'balance': newBalance.toString(),
          });
        }
      }
      await Database().updateWalletListFromFirestore();
      return true;
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Stream<List<WalletDTO>> getWalletListFromFirestore() {
    final firestoreInstance = FirebaseFirestore.instance;
    return firestoreInstance
        .collection('wallets')
        .where('userID', isEqualTo: GetData.getUID())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return WalletDTO(
          id: data['id'],
          name: data['name'],
          balance: BigInt.parse(data['balance']),
          userID: data['userID'],
        );
      }).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  static Stream<BigInt> getTotalBalanceFromFirestore() {
    return FirebaseFirestore.instance
        .collection('wallets')
        .where('userID', isEqualTo: GetData.getUID())
        .snapshots()
        .map((snapshot) {
      BigInt totalBalance = BigInt.zero;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalBalance += BigInt.parse(data['balance']);
      }
      return totalBalance;
    });
  }

  static Future<String> editWalletOnFirestore(int walletId, String newWalletName, String newBalance, BuildContext context) async {
    try {
      var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('id', isEqualTo: walletId)
          .get();
      var walletData = walletSnapshot.docs.first.data();
      String currentName = walletData['name'];
      String currentBalance = walletData['balance'];

      // Check if the new name or balance is different from the current name or balance
      if (newWalletName == currentName && newBalance == currentBalance) {
        // If both the name and balance are the same, do not update the wallet
        return 'noChange';
      }

      // Get the total balance from transactions associated with the wallet
      var transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('walletID', isEqualTo: walletId)
          .get();
      BigInt totalTransactionAmount = BigInt.zero;
      for (var doc in transactionSnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        BigInt transactionAmount = (data['amount'] != null) ? BigInt.parse(data['amount']) : BigInt.zero;
        totalTransactionAmount += transactionAmount;
      }

      // Check if the new balance is less than the total transaction balance
      if (BigInt.parse(newBalance) < totalTransactionAmount) {
        // If the new balance is less, do not update the wallet
        return 'badBalance';
      }

      // Check if a wallet with the new name already exists
      var nameSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('name', isEqualTo: newWalletName)
          .get();

      if (nameSnapshot.docs.isNotEmpty && currentBalance == newBalance) {
        // If a wallet with the new name exists, do not update the wallet
        return 'nameExists';
      }

      // If the new balance is not less, update the wallet
      await walletSnapshot.docs.first.reference.update({
        'name': newWalletName,
        'balance': newBalance,
      });
      await Database().updateWalletListFromFirestore();
      return 'success';
    } catch (e) {
      // If an error occurs, catch it and return an error message
      return e.toString();
    }
  }
}