import 'package:money_tracking/functions/converter.dart';

import '../../objects/dtos/transaction_dto.dart';
import '../../objects/models/transaction_model.dart';
import '../database/database.dart';
import '../firebase/firebase.dart';

class TransactionBUS {
  static void addTransaction(TransactionModel transaction) {
    Firebase().transactionList.add(
      TransactionDTO(
        id: transaction.id,
        name: transaction.name,
        categoryID: transaction.category.id,
        walletID: transaction.wallet.id,
        amount: transaction.amount,
        date: Converter.toTimestamp(transaction.date),
        note: transaction.note,
        userID: "abc",
      ),
    );
    Database().updateTransactionList();
  }
}