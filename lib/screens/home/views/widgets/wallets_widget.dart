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
    List<WalletDTO> wallets = _getWallets();
    BigInt totalBalance = _getTotalBalance();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallets'),
      ),
      body: Column(
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
                trailing: Text(
                  NumberFormat.currency(
                    locale: 'vi',
                    symbol: '₫',
                  ).format(wallet.balance.toDouble()),
                  style: const TextStyle(
                      fontSize: 16
                  ),
                ), // Số dư của ví
                onTap: () {
                  // Chuyển hướng đến trang khác (dummy screen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DummyScreen(wallet: wallet)),
                  );
                },
              )).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chuyển hướng đến trang thêm ví mới (dummy screen)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWalletScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Widget header hiển thị tổng số dư
  Widget _buildTotalBalanceHeader(BigInt totalBalance) {
    return ListTile(
      title: const Text(
        'Total Balance',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ), // Tiêu đề tổng số dư
      trailing: Text(
        NumberFormat.currency(
          locale: 'vi',
          symbol: '₫',
        ).format(totalBalance.toDouble()), // Hiển thị tổng số dư
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class DummyScreen extends StatelessWidget {
  final WalletDTO wallet;

  const DummyScreen({Key? key, required this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wallet.name),
      ),
      body: Center(
        child: Text('This is a dummy screen for ${wallet.name}'),
      ),
    );
  }
}

class AddWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wallet'),
      ),
      body: Center(
        child: Text('This is a dummy screen for adding a new wallet'),
      ),
    );
  }
}
