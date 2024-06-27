import 'budget_detail_model.dart';

class BudgetModel {
  final int id;
  final int month;
  final int year;
  final List<BudgetDetailModel> budgetDetails;
  final String userID;

  BudgetModel({
    required this.id,
    required this.month,
    required this.year,
    required this.budgetDetails,
    required this.userID,
  });
}