import 'package:bloc/bloc.dart';
import 'package:money_tracking/screens/transaction/cubits/transaction_screen_state.dart';

import '../../../data/database/database.dart';
import '../../../objects/models/transaction_model.dart';

class TransactionScreenCubit extends Cubit<TransactionScreenState> {
  TransactionScreenCubit() : super(
      TransactionScreenState(
        selectedDate: DateTime.now(),
      ));

  void updateTransactionListStream() async {
    await Database().updateTransactionListStream();
    emit(state.copyWith(
      transactionListStream: Database().transactionListStream,
    ));
  }

  void updateSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate));
  }

  void filterTransactions(List<TransactionModel> transactions) {
    final selectedDate = state.selectedDate;
    final startOfMonth = DateTime(selectedDate.year, selectedDate.month);
    final endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final filteredTransactions = transactions.where((transaction) {
      return transaction.date.isAfter(startOfMonth) &&
          transaction.date.isBefore(endOfMonth);
    }).toList();

    emit(state.copyWith(filteredTransactions: filteredTransactions));
  }
}