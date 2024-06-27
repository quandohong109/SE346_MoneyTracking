import 'package:money_tracking/data/buses/wallet_bus.dart';
import 'package:money_tracking/objects/models/icon_type.dart';

class WalletModel {
  final int id;
  final String name;
  BigInt balance;

  WalletModel({
    required this.id,
    required this.name,
    required this.balance,
  });

  // bool addBalance(BigInt amount) {
  //   return WalletBUS.changeBalance(amount, id);
  // }
  //
  // bool subtractBalance(BigInt amount) {
  //   return WalletBUS.changeBalance(-amount, id);
  // }

  @override
  String toString() {
    return 'WalletModel{id: $id, name: $name, balance: $balance}';
  }

  String getName() {
    return name;
  }
}