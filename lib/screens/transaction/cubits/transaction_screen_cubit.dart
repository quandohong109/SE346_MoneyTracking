import 'package:bloc/bloc.dart';
import 'package:money_tracking/screens/transaction/cubits/transaction_screen_state.dart';

import '../../../data/database/database.dart';

class TransactionScreenCubit extends Cubit<TransactionScreenState> {
  TransactionScreenCubit() : super(
      TransactionScreenState(
        startOfMonth: DateTime(DateTime.now().year, DateTime.now().month),
        endOfMonth: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ));

  void updateTransactionListStream() {
    Database().updateTransactionListStream();
    emit(state.copyWith(transactionListStream: Database().transactionListStream));
  }
}