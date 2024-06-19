import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionWidget({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: transaction.category.color,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  transaction.category.iconType.icon,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
            title: Text(
              transaction.category.name,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            subtitle: Row(
              children: [
                const Icon(
                  Icons.wallet,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  transaction.wallet.name,
                ),
              ],
            ),
            trailing: Text(
              "${transaction.category.isIncome ? '+' : '-'}${NumberFormat.currency(
                locale: 'vi',
                symbol: '₫',
              ).format(transaction.amount.toDouble())}",
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: transaction.category.isIncome ? Colors.green : Colors.red),
            )
        ),
      ),
    );
  }
}
