import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/firebase/firebase.dart';
import '../../../../objects/dtos/wallet_dto.dart';

class WalletsWidget extends StatefulWidget {
  @override
  _WalletsWidgetState createState() => _WalletsWidgetState();
}

class _WalletsWidgetState extends State<WalletsWidget> {
  int _displayCount = 5;

  List<WalletDTO> _getWallets() {
    Firebase firebaseInstance = Firebase();
    List<WalletDTO> wallets = firebaseInstance.walletList;
    if (wallets.length > _displayCount) {
      wallets = wallets.sublist(0, _displayCount);
    }
    return wallets;
  }

  BigInt _getTotalBalance() {
    Firebase firebaseInstance = Firebase();
    return firebaseInstance.walletList.fold(BigInt.zero, (prev, element) => prev + element.balance);
  }

  @override
  Widget build(BuildContext context) {
    List<WalletDTO> wallets = _getWallets();
    BigInt totalBalance = _getTotalBalance();
    return Column(
      children: [
        Text('Total Balance: $totalBalance'),
        Expanded(
          child: ListView.builder(
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(wallets[index].name),
                trailing: Text(wallets[index].balance.toString()),
              );
            },
          ),
        ),
        if (Firebase().walletList.length > _displayCount)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _displayCount += 5;
              });
            },
            child: Text('Xem thêm'),
          ),
      ],
    );
  }
}