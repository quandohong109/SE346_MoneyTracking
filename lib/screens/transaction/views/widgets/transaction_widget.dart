import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';
import 'package:money_tracking/screens/main/add_transaction/view/modify_transaction_screen.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onPress;
  final ValueNotifier<bool> isExpandedNotifier = ValueNotifier<bool>(false);

  TransactionWidget({
    super.key,
    required this.transaction,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          isExpandedNotifier.value = !isExpandedNotifier.value;
        },
        child: ValueListenableBuilder(
            valueListenable: isExpandedNotifier,
            builder: (context, isExpanded, child) {
              return isExpanded
                  ? Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: transaction.category.color, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                surfaceTintColor: Colors.white,
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${transaction.category.isIncome ? '+' : '-'}${NumberFormat.currency(
                              locale: 'vi',
                              symbol: '₫',
                            ).format(transaction.amount.toDouble())}",
                            textAlign: TextAlign.center,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                color: transaction.category.isIncome
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Icon(
                                  transaction.category.iconType.icon,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                transaction.category.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.wallet,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                transaction.wallet.name,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.calendar,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('dd/MM/yyyy').format(transaction.date),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),

                          if (transaction.note != null && transaction.note!.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.pencil,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        transaction.note!,
                                        softWrap: true,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ModifyTransactionScreen.newInstanceWithTransaction(transaction: transaction),
                            ),
                          );
                          onPress();
                        },
                      ),
                    ),
                  ],
                ),
              )
                  : Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
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
                                  FontAwesomeIcons.wallet,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  transaction.wallet.name,
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${transaction.category.isIncome ? '+' : '-'}${NumberFormat.currency(
                                      locale: 'vi',
                                      symbol: '₫',
                                    ).format(transaction.amount.toDouble())}",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: transaction.category.isIncome ? Colors.green : Colors.red),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(transaction.date),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 0,
                        child: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        ModifyTransactionScreen.newInstanceWithTransaction(transaction: transaction)
                                ),
                              );
                              onPress();
                            }
                        ),
                      ),
                    ]
                ),
              );
            })
    );
  }
}
