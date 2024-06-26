import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      await Database().updateTransactionListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Transaction: ${e.toString()}");
    }
  }

  static Future<void> updateTransactionToFirestore(TransactionModel transaction) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection(
          'transactions')
          .where('id', isEqualTo: transaction.id)
          .get();
      for (var doc in querySnapshot.docs) {
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
