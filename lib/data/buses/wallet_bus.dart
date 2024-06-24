import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  static Future<void> addWalletToFirestore(WalletModel wallet, BuildContext context) async {
    try {
      // Check if a wallet with the same name already exists
      var nameSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('name', isEqualTo: wallet.name)
          .get();

      if (nameSnapshot.docs.isNotEmpty) {
        // If a wallet with the same name exists, show an AlertDialog and do not add the new wallet
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cannot add wallet'),
            content: const Text('A wallet with this name already exists.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // If no wallet with the same name exists, add the new wallet
        var idSnapshot = await FirebaseFirestore.instance.collection('wallets').orderBy('id', descending: true).limit(1).get();
        var data = idSnapshot.docs.first.data();
        int maxId = data['id'];
        int newId = maxId + 1;

        await FirebaseFirestore.instance.collection('wallets').add({
          'id': newId,
          'name': wallet.name,
          'balance': wallet.balance.toString(),
          'userID': GetData.getUID(),
        });

        await Database().updateWalletListFromFirestore();
      }
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<void> deleteWalletFromFirestore(int walletId, BuildContext context) async {
    try {
      // Check if there are any transactions associated with the wallet
      var transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('walletID', isEqualTo: walletId)
          .get();

      if (transactionSnapshot.docs.isNotEmpty) {
        // If there are transactions, show an AlertDialog and do not delete the wallet
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cannot delete wallet'),
            content: const Text('This wallet has associated transactions and cannot be deleted.'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // If there are no transactions, delete the wallet and show an AlertDialog
        var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
            .where('id', isEqualTo: walletId)
            .get();
        for (var doc in walletSnapshot.docs) {
          await doc.reference.delete();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Wallet deleted'),
            content: const Text('The wallet has been successfully deleted.'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        await Database().updateWalletListFromFirestore();
      }
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  static Future<void> updateWalletOnFirestore(int walletId, String newName, BigInt newBalance, BuildContext context) async {
    try {
      // Check if a wallet with the same name already exists
      var nameSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('name', isEqualTo: newName)
          .get();

      if (nameSnapshot.docs.isNotEmpty && nameSnapshot.docs.first.id != walletId.toString()) {
        // If a wallet with the same name exists and it's not the current wallet, show an AlertDialog and do not update the wallet
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cannot update wallet'),
            content: const Text('A wallet with this name already exists.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Get the total value of all transactions associated with the wallet
        var transactionSnapshot = await FirebaseFirestore.instance.collection('transactions')
            .where('walletID', isEqualTo: walletId)
            .get();

        BigInt totalTransactionValue = BigInt.zero;
        for (var doc in transactionSnapshot.docs) {
          totalTransactionValue += BigInt.parse(doc.data()['value']);
        }

        if (totalTransactionValue > newBalance) {
          // If the total transaction value is greater than the new balance, show an AlertDialog and do not update the balance
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cannot update wallet balance'),
              content: Text('The new balance is less than the total value of transactions associated with this wallet. Current balance: ${totalTransactionValue.toString()}'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // If the total transaction value is not greater than the new balance, update the wallet name and balance
          var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
              .where('id', isEqualTo: walletId)
              .get();
          for (var doc in walletSnapshot.docs) {
            await doc.reference.update({
              'name': newName,
              'balance': newBalance.toString(),
            });
          }
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Wallet updated'),
              content: const Text('The wallet has been successfully updated.'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          await Database().updateWalletListFromFirestore();
        }
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

  static Future<void> decreaseWalletBalanceOnFirestore(int walletId, BigInt transactionValue, BuildContext context) async {
    try {
      var walletSnapshot = await FirebaseFirestore.instance.collection('wallets')
          .where('id', isEqualTo: walletId)
          .get();
      for (var doc in walletSnapshot.docs) {
        BigInt currentBalance = BigInt.parse(doc.data()['balance']);
        if (transactionValue > currentBalance) {
          // If the transaction value is greater than the current balance, show an AlertDialog and do not decrease the balance
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cannot decrease wallet balance'),
              content: const Text('The transaction value is greater than the current wallet balance.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          BigInt newBalance = currentBalance - transactionValue;
          await doc.reference.update({
            'balance': newBalance.toString(),
          });
        }
      }
      await Database().updateWalletListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }
}