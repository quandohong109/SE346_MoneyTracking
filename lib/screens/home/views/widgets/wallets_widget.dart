import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        SizedBox(
          height: 150, // Chiều cao cố định của ListView
          child: ListView(
            children: wallets.map((wallet) => ListTile(
              title: Text(
                  wallet.name,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ), // Tên ví
              trailing: Text(NumberFormat.currency(
                locale: 'vi',
                symbol: '₫',
                ).format(wallet.balance.toDouble()),
                style: const TextStyle(
                  fontSize: 16
                ),
              ), // Số dư của ví
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Total Balance', // Tiêu đề tổng số dư
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            NumberFormat.currency(
              locale: 'vi',
              symbol: '₫',
            ).format(totalBalance.toDouble()), // Hiển thị tổng số dư
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}