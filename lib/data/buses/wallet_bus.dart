import 'package:money_tracking/data/firebase/firebase.dart';

class WalletBUS {
  static bool changeBalance(BigInt amount, int walletID) {
    return Firebase().walletList.where((e) => e.id == walletID).first.changeBalance(amount);
  }
}