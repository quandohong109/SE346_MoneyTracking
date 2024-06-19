import 'package:flutter/material.dart';
import 'package:money_tracking/data/firebase/firebase.dart';
import 'package:money_tracking/functions/converter.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import '../../objects/models/icon_type.dart';
import '../../objects/models/transaction_model.dart';
import '../../objects/models/wallet_model.dart';

class Database {
  static final Database _database = Database._internal();

  factory Database() {
    return _database;
  }

  Database._internal();

  List<IconType> iconTypeList = [
    IconType(id: 1, icon: Icons.cake),
    IconType(id: 2, icon: Icons.savings),
    IconType(id: 3, icon: Icons.build),
    IconType(id: 4, icon: Icons.pets),
    IconType(id: 5, icon: Icons.phone),
    IconType(id: 6, icon: Icons.sports_esports),
    IconType(id: 7, icon: Icons.router),
    IconType(id: 8, icon: Icons.outdoor_grill),
    IconType(id: 9, icon: Icons.restaurant),
    IconType(id: 10, icon: Icons.shopping_cart),
    IconType(id: 11, icon: Icons.train),
    IconType(id: 12, icon: Icons.local_gas_station),
  ];

  List<CategoryModel> categoryList = [];
  List<WalletModel> walletList = [];
  List<TransactionModel> transactionList = [];

  void updateCategoryList() {
    categoryList = Firebase().categoryList.map((e) {
      return CategoryModel(
        id: e.id,
        name: e.name,
        iconType: iconTypeList.firstWhere((element) => element.id == e.iconID),
        isIncome: e.isIncome,
        color: Color.fromRGBO(e.red, e.green, e.blue, e.opacity),
      );
    }).toList();
  }

  void updateWalletList() {
    walletList = Firebase().walletList.map((e) {
      return WalletModel(
        id: e.id,
        name: e.name,
        icon: iconTypeList.firstWhere((element) => element.id == e.iconID),
        balance: e.balance,
      );
    }).toList();
  }

  void updateTransactionList() {
    updateCategoryList();
    updateWalletList();
    transactionList = Firebase().transactionList.map((e) {
      return TransactionModel(
        id: e.id,
        category: categoryList.firstWhere((element) => element.id == e.categoryID),
        wallet: walletList.firstWhere((element) => element.id == e.walletID),
        date: Converter.toDateTime(e.date),
        note: e.note,
        amount: e.amount,
        isExpanded: false,
      );
    }).toList();
  }
}