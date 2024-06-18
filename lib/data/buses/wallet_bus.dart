import 'package:money_tracking/data/firebase/firebase.dart';

class WalletBUS {
  static bool changeBalance(BigInt amount, int walletID) {
    return Firebase().walletList.where((e) => e.id == walletID).first.changeBalance(amount);
  }

  //Task: Create a new wallet in Firestore

  //Task: Change the balance of the wallet in Firestore
}