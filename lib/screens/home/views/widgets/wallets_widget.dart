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
  int _selectedIndex = -1;

  // Hàm lấy danh sách 5 ví đầu tiên từ Firebase
  List<WalletDTO> _getWallets() {
    Firebase firebaseInstance = Firebase();
    return firebaseInstance.walletList;
  }

  // Hàm tính tổng số dư của 5 ví đầu tiên
  BigInt _getTotalBalance() {
    Firebase firebaseInstance = Firebase();
    return firebaseInstance.walletList.fold(
        BigInt.zero, (prev, element) => prev + element.balance);
  }

  @override
  Widget build(BuildContext context) {
    List<WalletDTO> wallets = _getWallets();
    BigInt totalBalance = _getTotalBalance();

    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          // Add some spacing from the top
          Text(
            'Wallets',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Add spacing between the title and content
          _buildTotalBalanceHeader(totalBalance),
          // Widget header hiển thị tổng số dư
          Container(
            color: Colors.pink, // Set the background color to pink
            child: SizedBox(
              height: 150, // Chiều cao cố định của ListView
              child: ListView.builder(
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  WalletDTO wallet = wallets[index];

                  return Container(
                    child: ListTile(
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
                          fontSize: 16,
                        ),
                      ), // Số dư của ví
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        // Chuyển hướng đến trang khác (dummy screen)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              DummyScreen(wallet: wallet)),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          _buildAddWalletButton(),
          // Nút thêm ví ở dưới cùng
        ],
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

  // Widget nút thêm ví ở dưới cùng
  Widget _buildAddWalletButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity, // Make the button expand horizontally
        child: OutlinedButton(
          onPressed: () {
            // Navigate to add wallet screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddWalletScreen()),
            );
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue,
            // Set background color directly to blue
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            side: BorderSide(
                color: Colors.blue), // Border color when button is enabled
          ),
          child: Text(
            '+Add Wallet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white, // Text color
            ),
          ),
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
        title: const Text('Add Wallet'),
      ),
      body: const Center(
        child: Text('This is a dummy screen for adding a new wallet'),
      ),
    );
  }
}
