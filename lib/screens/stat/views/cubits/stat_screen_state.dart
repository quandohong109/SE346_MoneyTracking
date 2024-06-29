import 'package:equatable/equatable.dart';

import '../../../../objects/models/category_model.dart';
import '../../../../objects/models/transaction_model.dart';

class StatScreenState with EquatableMixin {
  final DateTime selectedDate;
  final DateTime beginDate;
  final DateTime endDate;
  final Stream<List<TransactionModel>> transactionListStream;
  final double income;
  final double expense;
  final List<TransactionModel> transactionList;
  final List<CategoryModel> incomeCategoryList;
  final List<CategoryModel> expenseCategoryList;

  const StatScreenState({
    required this.selectedDate,
    required this.beginDate,
    required this.endDate,
    this.transactionListStream = const Stream.empty(),
    this.income = 0.0,
    this.expense = 0.0,
    this.transactionList = const [],
    this.incomeCategoryList = const [],
    this.expenseCategoryList = const [],
  });

  @override
  List<Object?> get props => [selectedDate, beginDate, endDate, transactionListStream, income, expense, transactionList, incomeCategoryList, expenseCategoryList];

  StatScreenState copyWith({
    DateTime? selectedDate,
    DateTime? beginDate,
    DateTime? endDate,
    Stream<List<TransactionModel>>? transactionListStream,
    double? income,
    double? expense,
    List<TransactionModel>? transactionList,
    List<CategoryModel>? incomeCategoryList,
    List<CategoryModel>? expenseCategoryList,
  }) {
    return StatScreenState(
      selectedDate: selectedDate ?? this.selectedDate,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
      transactionListStream: transactionListStream ?? this.transactionListStream,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      transactionList: transactionList ?? this.transactionList,
      incomeCategoryList: incomeCategoryList ?? this.incomeCategoryList,
      expenseCategoryList: expenseCategoryList ?? this.expenseCategoryList,
    );
  }
}