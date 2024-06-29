import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/transaction/views/widgets/transaction_widget.dart';

import '../../../objects/models/transaction_model.dart';
import '../../main/month_picker.dart';
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
        body: BlocBuilder<TransactionScreenCubit, TransactionScreenState>(
            builder: (context, state) {
              return Column(
                children: [
                  MonthPicker(
                    selectedDate: state.selectedDate,
                    updateSelectedDate: (DateTime newDate) {
                      cubit.updateSelectedDate(newDate);
                    },
                  ),
                  Expanded(
                    child: StreamBuilder<List<TransactionModel>>(
                      stream: cubit.state.transactionListStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          cubit.filterTransactions(snapshot.data!);
                          final thisMonthTransactions = cubit.state.filteredTransactions;
                          if (thisMonthTransactions.isEmpty) {
                            return const Center(child: Text('No categories found'));
                          } else {
                            return ListView.builder(
                              itemCount: thisMonthTransactions.length,
                              itemBuilder: (context, index) {
                                return TransactionWidget(
                                    transaction: thisMonthTransactions[index],
                                    onPress: () =>
                                    {
                                      cubit.updateTransactionListStream(),
                                    }
                                );
                              },
                            );
                          }
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}