import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/data/firebase/firebase.dart';
import 'package:money_tracking/functions/converter.dart';
import 'package:money_tracking/objects/models/budget_model.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import '../../functions/getdata.dart';
import '../../objects/models/budget_detail_model.dart';
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
    IconType(id: 13, icon: Icons.card_travel),
    IconType(id: 14, icon: Icons.garage),
    IconType(id: 15, icon: Icons.home_work),
    IconType(id: 16, icon: Icons.add_box),
    IconType(id: 17, icon: Icons.money),
    IconType(id: 18, icon: Icons.electric_bolt),
    IconType(id: 19, icon: Icons.water_drop),
    IconType(id: 20, icon: Icons.local_library),
  ];

  List<CategoryModel> categoryList = [];
  List<WalletModel> walletList = [];
  List<TransactionModel> transactionList = [];

  Stream<List<TransactionModel>> transactionListStream = const Stream.empty();
  Stream<List<BudgetModel>> budgetListStream = const Stream.empty();

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

  // void updateWalletList() {
  //   walletList = Firebase().walletList.map((e) {
  //     return WalletModel(
  //       id: e.id,
  //       name: e.name,
  //       balance: e.balance,
  //     );
  //   }).toList();
  // }

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
          iconType: iconTypeList.firstWhere((element) =>
          element.id == data['iconID']),
          isIncome: data['isIncome'],
          color: Color.fromRGBO(
              data['red'], data['green'], data['blue'], data['opacity']),
        );
      }).toList();
      categoryList.sort((a, b) => a.name.compareTo(b.name));
      if (kDebugMode) {
        print(categoryList);
      }
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Category: ${e.toString()}");
    }
  }

  Future<void> updateWalletListFromFirestore() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestoreInstance
          .collection('wallets')
          .where('userID', isEqualTo: GetData.getUID())
          .get();

      walletList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return WalletModel(
          id: data['id'],
          name: data['name'],
          balance: BigInt.parse(data['balance']),
        );
      }).toList();
      walletList.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      // If an error occurs, catch it and show an error toast
      throw Exception("An error occurred - Wallet: ${e.toString()}");
    }
  }

  Future<void> updateTransactionListFromFirestore() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final QuerySnapshot querySnapshot = await firestoreInstance
          .collection('transactions')
          .where('userID', isEqualTo: GetData.getUID())
          .get();

      await updateCategoryListFromFirestore();
      await updateWalletListFromFirestore();

      transactionList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return TransactionModel(
          id: data['id'],
          category: categoryList.firstWhere((element) =>
          element.id == data['categoryID']),
          wallet: walletList.firstWhere((element) =>
          element.id == data['walletID']),
          date: (data['date'] as Timestamp).toDate(),
          note: data['note'] ?? '',
          amount: Converter.toBigInt(data['amount']),
          isExpanded: false,
        );
      }).toList();
      transactionList.sort((a, b) => b.date.compareTo(a.date));
      await Database().updateTransactionListStream();
    } catch (e) {
      throw Exception("An error occurred - Transaction: ${e.toString()}");
    }
  }

  Future<void> updateTransactionListStream() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      transactionListStream = firestoreInstance
          .collection('transactions')
          .where('userID', isEqualTo: GetData.getUID())
          .snapshots()
          .asyncMap((querySnapshot) async {
        await updateCategoryListFromFirestore();
        await updateWalletListFromFirestore();

        var transactions = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return TransactionModel(
            id: data['id'],
            category: categoryList.firstWhere((element) =>
            element.id == data['categoryID']),
            wallet: walletList.firstWhere((element) =>
            element.id == data['walletID']),
            date: (data['date'] as Timestamp).toDate(),
            note: data['note'] ?? '',
            amount: Converter.toBigInt(data['amount']),
            isExpanded: false,
          );
        }).toList();

        // Sort the transactions by date in descending order
        transactions.sort((a, b) => b.date.compareTo(a.date));
        return transactions;
      });
    } catch (e) {
      throw Exception("An error occurred - Transaction: ${e.toString()}");
    }
  }

  Future<void> updateBudgetListStream() async {
    try {
      await updateCategoryListFromFirestore();
      final firestoreInstance = FirebaseFirestore.instance;
      // Fetch budget_details from Firestore
      final QuerySnapshot budgetDetailsQuerySnapshot = await firestoreInstance
          .collection('budget_details')
          .where('userID', isEqualTo: GetData.getUID())
          .get();

      // Map budget_details to BudgetDetailModel objects
      final budgetDetails = budgetDetailsQuerySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return BudgetDetailModel(
          budgetID: data['budgetID'],
          category: categoryList.firstWhere((element) =>
          element.id == data['categoryID']),
          amount: Converter.toBigInt(data['amount']),
          userID: data['userID'],
        );
      }).toList();

      budgetListStream = firestoreInstance
          .collection('budgets')
          .where('userID', isEqualTo: GetData.getUID())
          .snapshots()
          .asyncMap((querySnapshot) async {
        var budgets = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();

          // Filter budgetDetails for the current BudgetModel
          var details = budgetDetails.where((detail) =>
          detail.budgetID == data['id']).toList();

          return BudgetModel(
            id: data['id'],
            month: data['month'],
            year: data['year'],
            otherAmount: Converter.toBigInt(data['otherAmount']),
            budgetDetails: details,
            userID: data['userID'],
          );
        }).toList();
        return budgets;
      });
    } on Exception {
      rethrow;
    }
  }

  Future<void> updateBudgetListStreamTest() async {
    try {
      await updateCategoryListFromFirestore();
      final firebaseInstance = Firebase();

      final budgetDetails = firebaseInstance.budgetDetailList.map((detailDTO) {
        // Create a BudgetDetailModel
        return BudgetDetailModel(
          budgetID: detailDTO.budgetID,
          category: categoryList.firstWhere((element) => element.id == detailDTO.categoryID),
          amount: detailDTO.amount,
          userID: detailDTO.userID,
        );
      }).toList();

      var budgets = firebaseInstance.budgetList.map((budget) {
        var details = budgetDetails.where((detail) =>
        detail.budgetID == budget.id).toList();

        return BudgetModel(
          id: budget.id,
          month: budget.month,
          year: budget.year,
          otherAmount: budget.otherAmount,
          budgetDetails: details,
          userID: budget.userID,
        );
      }).toList();

      // Convert the list of BudgetModel objects to a stream
      budgetListStream = Stream.value(budgets);
    } on Exception {
      rethrow;
    }
  }
}
