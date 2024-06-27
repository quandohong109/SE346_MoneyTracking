class BudgetDTO {
  final int id;
  final int month;
  final int year;
  final BigInt otherAmount;
  final String userID;

  BudgetDTO({
    required this.id,
    required this.month,
    required this.year,
    required this.otherAmount,
    required this.userID,
  });
}