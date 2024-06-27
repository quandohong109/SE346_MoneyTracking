import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_tracking/data/buses/wallet_bus.dart';
import 'package:money_tracking/functions/converter.dart';
import 'package:money_tracking/objects/models/wallet_model.dart';

import '../../functions/custom_exception.dart';
import '../../objects/dtos/transaction_dto.dart';
import '../../objects/models/transaction_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';
import '../../functions/getdata.dart';

class TransactionBUS {
  static Future<void> addTransactionToFirestore(TransactionModel transaction) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'transactions').orderBy('id', descending: true).limit(1).get();
      int newId = 1; // Default value
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        int maxId = data['id'];
        newId = maxId + 1;
      }

      if (transaction.category.isIncome) {
        await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
      } else {
        await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
      }

      // Now use newId for the new transaction
      await FirebaseFirestore.instance.collection('transactions').add({
        'id': newId,
        'categoryID': transaction.category.id,
        'walletID': transaction.wallet.id,
        'amount': transaction.amount.toString(),
        'date': Converter.toTimestamp(transaction.date),
        'note': transaction.note,
        'userID': GetData.getUID(),
      });

      await Database().updateTransactionListFromFirestore();
    } on Exception {
      rethrow;
    }
  }

  static Future<void> deleteTransactionFromFirestore(int transactionId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('id', isEqualTo: transactionId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      final TransactionModel transaction = Database().transactionList.where((e) => e.id == transactionId).first;

      if (transaction.category.isIncome) {
        await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
      } else {
        await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
      }
      await Database().updateTransactionListFromFirestore();
    } on Exception {
      // If an error occurs, catch it and show an error toast
      rethrow;
    }
  }

  static Future<void> updateTransactionToFirestore(TransactionModel transaction) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('id', isEqualTo: transaction.id)
          .get();

      final TransactionModel oldTransaction = Database().transactionList.where((e) => e.id == transaction.id).first;
      final WalletModel oldWallet = Database().walletList.where((e) => e.id == oldTransaction.wallet.id).first;
      final WalletModel newWallet = Database().walletList.where((e) => e.id == transaction.wallet.id).first;

      if (oldWallet.id == newWallet.id) {
        if (oldTransaction.category.isIncome) {
          newWallet.balance -= oldTransaction.amount;
        } else {
          newWallet.balance += oldTransaction.amount;
        }

        if (transaction.category.isIncome) {
          newWallet.balance += transaction.amount;
        } else {
          newWallet.balance -= transaction.amount;
        }

        if (newWallet.balance < BigInt.zero) {
          throw CustomException("Transaction value is greater than the current wallet balance");
        }

        await FirebaseFirestore.instance.collection('wallets').doc(newWallet.id.toString()).update({
          'balance': newWallet.balance.toString(),
        });
      } else {
        if (oldTransaction.category.isIncome) {
          await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
        } else {
          await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
        }

        if (transaction.category.isIncome) {
          await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
        } else {
          await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
        }
      }

      for (var doc in querySnapshot.docs) {
        // Update the transaction
        await doc.reference.update({
          'categoryID': transaction.category.id,
          'walletID': transaction.wallet.id,
          'amount': transaction.amount.toString(),
          'date': Converter.toTimestamp(transaction.date),
          'note': transaction.note,
        });
      }
      await Database().updateTransactionListFromFirestore();
    } on Exception {
      rethrow;
    }
  }
}
