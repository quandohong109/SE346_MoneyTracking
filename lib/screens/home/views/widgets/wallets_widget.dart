import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../data/buses/wallet_bus.dart';
import '../../../../data/database/database.dart';
import '../../../../functions/custom_dialog.dart';
import '../../../../objects/dtos/wallet_dto.dart'; // Đường dẫn đến WalletDTO

class WalletsWidget extends StatefulWidget {
  const WalletsWidget({super.key});

  @override
  _WalletsWidgetState createState() => _WalletsWidgetState();
}

class _WalletsWidgetState extends State<WalletsWidget> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // Call updateWalletFromFirestore when the widget is first created
    Database().updateWalletListFromFirestore();
    // Call the two get functions from wallet_bus
    WalletBUS.getWalletListFromFirestore();
    WalletBUS.getTotalBalanceFromFirestore();
  }

  void showConfigureWalletDialog(BuildContext context, WalletDTO wallet) {
    final TextEditingController nameController = TextEditingController(text: wallet.name);
    final TextEditingController balanceController = TextEditingController(text: wallet.balance.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Make the AlertDialog square
          ),
          title: const Center(
            child: Text(
              'CONFIGURE WALLET',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the title bold
                fontSize: 18,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  labelText: 'Wallet name',
                  hintText: 'Enter wallet name...',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add space between the two TextFields
              TextField(
                controller: balanceController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.money),
                  labelText: 'Balance',
                  hintText: 'Enter initial balance...',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // Only allows digits
                ],
                onChanged: (value) {
                  if (double.tryParse(value) != null) {
                    if (double.parse(value) <= 0) {
                      // If the value is 0 or less, clear the input
                      balanceController.clear();
                    }
                  } else {
                    // If the value is not a number, clear the input
                    balanceController.clear();
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  onPressed: () {
                    CustomDialog.showConfirmDialog(
                        context,
                        'CONFIRMATION',
                        'Are you sure you want to edit this wallet information?',
                            () async {
                          String condition = await WalletBUS.editWalletOnFirestore(wallet.id, nameController.text, balanceController.text, context);
                          if (condition == 'noChange') {
                            Navigator.of(context).pop();
                            CustomDialog.showInfoDialog(context, 'NOTIFICATION', 'No changes have been made!');
                          } else if (condition == 'success') {
                            Navigator.of(context).pop();
                            CustomDialog.showInfoDialog(context, 'SUCCESS', 'The wallet has been successfully edited!');
                          } else if (condition == 'nameExists') {
                            CustomDialog.showInfoDialog(context, 'ERROR', 'The wallet name already exists!');
                          } else if (condition == 'badBalance'){
                            CustomDialog.showInfoDialog(context, 'ERROR', 'The edited balance cannot be less than the total of all transactions in the wallet. Please try again!');
                          } else {
                            CustomDialog.showInfoDialog(context, 'ERROR', condition);
                          }
                        },
                        onNoPressed: () {
                          Navigator.of(context).pop();
                        });
                  },
                  child: const Text('EDIT', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  onPressed: () {
                    CustomDialog.showConfirmDialog(
                        context,
                        'CONFIRMATION',
                        'Are you sure you want to delete this wallet?',
                            () async {
                          bool isDeleted = await WalletBUS.deleteWalletFromFirestore(wallet.id, context);
                          if (isDeleted == true) {
                            Navigator.of(context).pop();
                            CustomDialog.showInfoDialog(context, 'SUCCESS', 'The wallet has been successfully deleted!');
                          } else {
                            CustomDialog.showInfoDialog(context, 'ERROR', 'Cannot delete wallet with transactions associated!');
                          }
                        },
                        onNoPressed: () {
                          Navigator.of(context).pop();
                        }
                    );
                  },
                  child: const Text('DELETE', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BigInt>(
      stream: WalletBUS.getTotalBalanceFromFirestore(),
      builder: (BuildContext context, AsyncSnapshot<BigInt> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          BigInt totalBalance = snapshot.data!;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTotalBalanceHeader(totalBalance),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: SizedBox(
                    height: 190,
                    child: StreamBuilder<List<WalletDTO>>(
                      stream: WalletBUS.getWalletListFromFirestore(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<WalletDTO> wallets = snapshot.data!;
                          return ListView.builder(
                            itemCount: wallets.length,
                            itemBuilder: (context, index) {
                              WalletDTO wallet = wallets[index];
                              return Card(
                                elevation: 5,
                                child: ListTile(
                                  leading: const Icon(
                                    FontAwesomeIcons.wallet,
                                    color: Color(0xFF3e9c35),
                                  ),
                                  title: Text(
                                    wallet.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  trailing: Text(
                                    NumberFormat.currency(
                                      locale: 'vi',
                                      symbol: '₫',
                                    ).format(wallet.balance.toDouble()),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF3e9c35)
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                    showConfigureWalletDialog(context, wallet);
                                  },
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                _buildAddWalletButton(),
              ],
            ),
          );
        }
      },
    );
  }

  // Widget header hiển thị tổng số dư
  Widget _buildTotalBalanceHeader(BigInt totalBalance) {
    return ListTile(
      title: const Text(
        'TOTAL',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ), // Tiêu đề tổng số dư
      trailing: Text(
        NumberFormat.currency(
          locale: 'vi',
          symbol: '₫',
        ).format(totalBalance.toDouble()), // Hiển thị tổng số dư
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF3e9c35),
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
            _showAddWalletDialog(context);
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue,
            // Set background color directly to blue
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            side: const BorderSide(
                color: Colors.blue), // Border color when button is enabled
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add, // Add icon
                color: Colors.white,
              ),
              SizedBox(width: 8), // Space between icon and text
              Text(
                'Add Wallet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.wallet, // Add icon
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showAddWalletDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Make the AlertDialog square
        ),
        title: const Center(
          child: Text(
            'ADD WALLET',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_balance_wallet),
                labelText: 'Wallet name',
                hintText: 'Enter wallet name...',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 10), // Add space between the two TextFields
            TextField(
              controller: balanceController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money),
                labelText: 'Balance',
                hintText: 'Enter initial balance...',
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly, // Only allows digits
              ],
              onChanged: (value) {
                if (double.tryParse(value) != null) {
                  if (double.parse(value) <= 0) {
                    // If the value is 0 or less, clear the input
                    balanceController.clear();
                  }
                } else {
                  // If the value is not a number, clear the input
                  balanceController.clear();
                }
              },
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Set the border radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),// Text color
                ),
                child: const Text(
                  'CANCEL',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ValueListenableBuilder(
                valueListenable: nameController,
                builder: (context, _, __) {
                  return ValueListenableBuilder(
                    valueListenable: balanceController,
                    builder: (context, _, __) {
                      bool isEnabled = nameController.text.isNotEmpty && balanceController.text.isNotEmpty;
                      return TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: isEnabled ? Colors.green : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Set the border radius
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),// Text color
                        ),
                        onPressed: isEnabled ? () {
                          WalletBUS.addWalletToFirestore(nameController.text, balanceController.text, context);
                          Navigator.of(context).pop();
                          CustomDialog.showInfoDialog(context, 'Success', 'The wallet has been successfully added.');
                        } : null,
                        child: const Text(
                          'ADD',
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          )
        ],
      );
    },
  );
}