import 'package:bloc/bloc.dart';
import 'package:money_tracking/screens/transaction/cubits/transaction_screen_state.dart';

import '../../../data/database/database.dart';
import '../../../objects/models/category_model.dart';
import '../../../objects/models/transaction_model.dart';

class TransactionScreenCubit extends Cubit<TransactionScreenState> {
  TransactionScreenCubit() : super(const TransactionScreenState());

  void updateTransactionList() {
    Database().updateTransactionListFromFirestore();
    List<TransactionModel> transactionList = Database().transactionList;
    emit(state.copyWith(transactionList: transactionList));
  }
}