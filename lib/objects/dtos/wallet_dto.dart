class WalletDTO {
  final int id;
  final String name;
  BigInt balance;
  final String userID;

  WalletDTO({
    required this.id,
    required this.name,
    required this.balance,
    required this.userID,
  });

  bool changeBalance(BigInt amount) {
    balance += amount;
    return true;
  }
}