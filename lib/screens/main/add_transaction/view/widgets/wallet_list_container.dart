import 'package:money_tracking/screens/main/add_transaction/view/widgets/wallet_widget.dart';

import 'package:flutter/material.dart';
import '../../../../../objects/models/wallet_model.dart';

class WalletListContainer extends StatelessWidget {
  final bool isExpanded;
  final Color containerColor;
  final List<WalletModel> wallets;
  final Function(WalletModel) onWalletTap;
  final VoidCallback onEditTap;

  const WalletListContainer({
    super.key,
    required this.isExpanded,
    this.containerColor = Colors.white,
    required this.wallets,
    required this.onWalletTap,
    required this.onEditTap
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded ?
    wallets.isEmpty
        ? Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: containerColor,
        child: const Center(child: Text("There is no wallet yet.")))
        : Container(
      constraints: const BoxConstraints(maxHeight: 360.0, minHeight: 0.0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15.0)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: wallets.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10), // This is the separator
          itemBuilder: (BuildContext context, int index) {
            return WalletWidget(
              wallet: wallets[index],
              onTap: () => onWalletTap(wallets[index]),
              onEdit: () => onEditTap(),
            );
          },
        ),
      ),
    )
        : Container();
  }
}