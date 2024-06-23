import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/firebase/firebase.dart'; // Đường dẫn đến Firebase instance
import '../../../../objects/dtos/wallet_dto.dart'; // Đường dẫn đến WalletDTO

class WalletsWidget extends StatefulWidget {
  @override
  _WalletsWidgetState createState() => _WalletsWidgetState();
}

class _WalletsWidgetState extends State<WalletsWidget> {

  // Hàm lấy danh sách 5 ví đầu tiên từ Firebase
  List<WalletDTO> _getWallets() {
    Firebase firebaseInstance = Firebase();
    return firebaseInstance.walletList;
  }

  // Hàm tính tổng số dư của 5 ví đầu tiên
  BigInt _getTotalBalance() {
    Firebase firebaseInstance = Firebase();
    return firebaseInstance.walletList.fold(BigInt.zero, (prev, element) => prev + element.balance);
  }

  @override
  Widget build(BuildContext context) {
    List<WalletDTO> wallets = _getWallets(); // Lấy danh sách 5 ví đầu tiên
    BigInt totalBalance = _getTotalBalance(); // Tính tổng số dư của 5 ví đầu tiên

    return Column(
      children: [
        _buildTotalBalanceHeader(totalBalance), // Widget header hiển thị tổng số dư
        Container(
          height: 200, // Chiều cao cố định của ListView
          child: ListView(
            children: wallets.map((wallet) => ListTile(
              title: Text(wallet.name), // Tên ví
              trailing: Text('\$${wallet.balance.toString()}'), // Số dư của ví
            )).toList(),
          ),
        ),
      ],
    );
  }

  // Widget header hiển thị tổng số dư
  Widget _buildTotalBalanceHeader(BigInt totalBalance) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total Balance', // Tiêu đề tổng số dư
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${totalBalance.toString()}', // Hiển thị tổng số dư
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}