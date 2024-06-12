import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDTO {
  final int id;
  final String name;
  final int categoryID;
  final int walletID;
  final Timestamp date;
  final String note;
  final BigInt amount;
  final String userID;

  TransactionDTO({
    required this.id,
    required this.name,
    required this.categoryID,
    required this.walletID,
    required this.date,
    required this.note,
    required this.amount,
    required this.userID,
  });
}