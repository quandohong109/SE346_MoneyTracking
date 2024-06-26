import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking/objects/models/wallet_model.dart';

import 'package:flutter/material.dart';

class WalletWidget extends StatelessWidget {
  final WalletModel wallet;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const WalletWidget({
    super.key,
    required this.onEdit,
    required this.wallet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.wallet,
              size: 20,
              color: Color(0xA1171717),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                wallet.name,
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute<void>(
                //       builder: (BuildContext context) =>
                //           CategoryScreen.newInstanceWithCategory(category: wallet)
                //   ),
                // );
                onEdit();
              },
            ),
          ],
        ),
      ),
    );
  }
}