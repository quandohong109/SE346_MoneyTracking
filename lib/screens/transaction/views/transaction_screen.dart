import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/transaction/views/widgets/transaction_widget.dart';

import '../../../objects/models/transaction_model.dart';
import '../cubits/transaction_screen_cubit.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => TransactionScreenCubit(),
        child: const TransactionScreen(),
      );

  @override
  State<TransactionScreen> createState() => _TransactionScreen();
}

class _TransactionScreen extends State<TransactionScreen> {
  TransactionScreenCubit get cubit => context.read<TransactionScreenCubit>();

  @override
  void initState() {
    super.initState();
    cubit.updateTransactionListStream();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<TransactionModel>>(
                  stream: cubit.state.transactionListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final now = DateTime.now();
                      final startOfMonth = DateTime(now.year, now.month);
                      final endOfMonth = DateTime(now.year, now.month + 1, 0);
                      final thisMonthTransactions = snapshot.data!.where((transaction) {
                        return transaction.date.isAfter(startOfMonth) && transaction.date.isBefore(endOfMonth);
                      }).toList();
                      return ListView.builder(
                        itemCount: thisMonthTransactions.length,
                        itemBuilder: (context, index) {
                          return TransactionWidget(
                              transaction: thisMonthTransactions[index],
                              onPress: () => {
                                cubit.updateTransactionListStream(),
                              }
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}