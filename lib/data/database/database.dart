import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/data/firebase/firebase.dart';
import 'package:money_tracking/functions/converter.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import '../../functions/getdata.dart';
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

  // void updateCategoryList() {
  //   categoryList = Firebase().categoryList.map((e) {
  //     return CategoryModel(
  //       id: e.id,
  //       name: e.name,
  //       iconType: iconTypeList.firstWhere((element) => element.id == e.iconID),
  //       isIncome: e.isIncome,
  //       color: Color.fromRGBO(e.red, e.green, e.blue, e.opacity),
  //     );
  //   }).toList();
  // }

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

  // void updateTransactionList() {
  //   updateCategoryList();
  //   updateWalletList();
  //   transactionList = Firebase().transactionList.map((e) {
  //     return TransactionModel(
  //       id: e.id,
  //       category: categoryList.firstWhere((element) => element.id == e.categoryID),
  //       wallet: walletList.firstWhere((element) => element.id == e.walletID),
  //       date: Converter.toDateTime(e.date),
  //       note: e.note,
  //       amount: e.amount,
  //       isExpanded: false,
  //     );
  //   }).toList();
  // }

  Future<void> updateCategoryListFromFirestore() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestoreInstance
          .collection('categories')
          .where('userID', isEqualTo: GetData.getUID())
          .get();
      categoryList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CategoryModel(
          id: data['id'],
          name: data['name'],
          iconType: iconTypeList
              .firstWhere((element) => element.id == data['iconID']),
          isIncome: data['isIncome'],
          color: Color.fromRGBO(
              data['red'], data['green'], data['blue'], data['opacity']),
        );
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  void updateWalletListFromFirestore() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestoreInstance.collection('wallets')
        .where('userID', isEqualTo: GetData.getUID())
        .get();

    walletList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return WalletModel(
        id: data['id'],
        name: data['name'],
        icon: iconTypeList.firstWhere((element) => element.id == data['iconID']),
        balance: BigInt.parse(data['balance']),
      );
    }).toList();
    print(walletList);
  }

  void updateTransactionListFromFirestore() async {
    final firestoreInstance = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestoreInstance.collection('transactions')
        .where('userID', isEqualTo: GetData.getUID())
        .get();

    updateCategoryListFromFirestore();
    updateWalletListFromFirestore();

    transactionList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return TransactionModel(
        id: data['id'],
        category: categoryList.firstWhere((element) => element.id == data['categoryID']),
        wallet: walletList.firstWhere((element) => element.id == data['walletID']),
        date: (data['date'] as Timestamp).toDate(),
        note: data['note'],
        amount: BigInt.parse(data['amount']),
        isExpanded: false,
      );
    }).toList();
    print(transactionList);
  }
}