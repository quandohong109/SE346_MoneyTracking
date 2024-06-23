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
      var snapshot = await FirebaseFirestore.instance.collection('transactions').orderBy('id', descending: true).limit(1).get();
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      int maxId = data['id'];
      int newId = maxId + 1;

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

      // Show success toast
      // Fluttertoast.showToast(
      //     msg: "Transaction added successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );

      await Database().updateTransactionListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Transaction: ${e.toString()}");
    }
  }

  static void addTransaction(TransactionModel transaction) {
    Firebase().transactionList.add(
      TransactionDTO(
        id: transaction.id,
        categoryID: transaction.category.id,
        walletID: transaction.wallet.id,
        amount: transaction.amount,
        date: Converter.toTimestamp(transaction.date),
        note: transaction.note,
        userID: GetData.getUID(),
      ),
    );
    addTransactionToFirestore(transaction);
  }

  static Future<void> deleteTransactionFromFirestore(int transactionId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection('transactions')
          .where('id', isEqualTo: transactionId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      // Fluttertoast.showToast(
      //     msg: "Transaction deleted successfully!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      await Database().updateTransactionListFromFirestore();
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Transaction: ${e.toString()}");
    }
  }
}