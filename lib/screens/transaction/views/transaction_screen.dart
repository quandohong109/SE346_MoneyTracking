import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/transaction/views/widgets/transaction_widget.dart';

import '../cubits/transaction_screen_cubit.dart';
import '../cubits/transaction_screen_state.dart';

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
    cubit.updateTransactionList();
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
                child: BlocBuilder<TransactionScreenCubit, TransactionScreenState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.transactionList.length,
                      itemBuilder: (context, index) {
                        return TransactionWidget(
                            transaction: state.transactionList[index],
                            onTap: () => {}
                        );
                      },
                    );
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