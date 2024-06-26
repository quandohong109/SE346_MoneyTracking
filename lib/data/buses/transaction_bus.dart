import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_tracking/data/buses/wallet_bus.dart';
import 'package:money_tracking/functions/converter.dart';

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

  // static void addTransaction(TransactionModel transaction) {
  //   Firebase().transactionList.add(
  //     TransactionDTO(
  //       id: transaction.id,
  //       categoryID: transaction.category.id,
  //       walletID: transaction.wallet.id,
  //       amount: transaction.amount,
  //       date: Converter.toTimestamp(transaction.date),
  //       note: transaction.note ?? '',
  //       userID: GetData.getUID(),
  //     ),
  //   );
  //   addTransactionToFirestore(transaction);
  // }

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

      for (var doc in querySnapshot.docs) {
        // Get the old transaction details
        bool oldIsIncome = oldTransaction.category.isIncome;
        int oldWalletId = oldTransaction.wallet.id;
        BigInt oldAmount = oldTransaction.amount;

        // Update the transaction
        await doc.reference.update({
          'categoryID': transaction.category.id,
          'walletID': transaction.wallet.id,
          'amount': transaction.amount.toString(),
          'date': Converter.toTimestamp(transaction.date),
          'note': transaction.note,
        });

        // If the category has changed, update the wallet balance
        if (oldIsIncome != transaction.category.isIncome) {
          if (oldIsIncome) {
            // If the old transaction was an income and the new one is an expense, decrease the wallet balance
            await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
          } else {
            // If the old transaction was an expense and the new one is an income, increase the wallet balance
            await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
          }
        }

        // If the wallet has changed, update the old and new wallet balances
        if (oldWalletId != transaction.wallet.id) {
          // Decrease the old wallet balance
          await WalletBUS.decreaseWalletBalanceOnFirestore(oldWalletId, oldAmount);
          // Increase the new wallet balance
          await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount);
        }

        // If the amount has changed, update the wallet balance
        if (oldAmount != transaction.amount) {
          if (transaction.category.isIncome) {
            // If the transaction is an income, increase the wallet balance by the difference
            await WalletBUS.increaseWalletBalanceOnFirestore(transaction.wallet.id, transaction.amount - oldAmount);
          } else {
            // If the transaction is an expense, decrease the wallet balance by the difference
            await WalletBUS.decreaseWalletBalanceOnFirestore(transaction.wallet.id, oldAmount - transaction.amount);
          }
        }
      }
      await Database().updateTransactionListFromFirestore();
    } on Exception {
      rethrow;
    }
  }
}
