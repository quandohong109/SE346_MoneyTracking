class BudgetDetailDTO {
  final int budgetID;
  final int categoryID;
  final BigInt amount;
  final String userID;

  BudgetDetailDTO({
    required this.budgetID,
    required this.categoryID,
    required this.amount,
    required this.userID,
  });
}