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
  static void addTransactionToFirestore(TransactionModel transaction) {
    FirebaseFirestore.instance.collection('transactions').orderBy('id', descending: true).limit(1).get().then((snapshot) {
      int maxId = snapshot.docs.first.data()['id'];
      int newId = maxId + 1;

      // Now use newId for the new transaction
      FirebaseFirestore.instance.collection('transactions').add({
        'id': newId,
        'categoryID': transaction.category.id,
        'walletID': transaction.wallet.id,
        'amount': transaction.amount.toString(),
        'date': Converter.toTimestamp(transaction.date),
        'note': transaction.note,
        'userID': GetData.getUID(),
      }).then((_) {
        // Show success toast
        Fluttertoast.showToast(
            msg: "Transaction added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      });
      Database().updateTransactionListFromFirestore();
    });
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

  static void deleteTransactionFromFirestore(int transactionId) {
    FirebaseFirestore.instance.collection('transactions')
        .where('id', isEqualTo: transactionId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).then((_) {
      // FirebaseFirestore.instance.collection('wallets').doc(walletId.toString()).delete().then((_) { // ID is transaction's document ID
      Fluttertoast.showToast(
          msg: "Transaction deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
    Database().updateTransactionListFromFirestore();
  }
}