import 'package:money_tracking/objects/models/category_model.dart';

class BudgetDetailModel {
  final int budgetID;
  final CategoryModel category;
  final BigInt amount;
  final String userID;

  BudgetDetailModel({
    required this.budgetID,
    required this.category,
    required this.amount,
    required this.userID,
  });
}