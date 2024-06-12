class WalletDTO {
  final int id;
  final String name;
  final int iconID;
  BigInt balance;
  final String userID;

  WalletDTO({
    required this.id,
    required this.name,
    required this.iconID,
    required this.balance,
    required this.userID,
  });

  bool changeBalance(BigInt amount) {
    balance += amount;
    return true;
  }
}