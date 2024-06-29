import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_tracking/data/buses/transaction_bus.dart';
import 'package:money_tracking/data/database/database.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';

import '../../../../objects/models/category_model.dart';
import '../../../../objects/models/execute_status.dart';
import '../../../../objects/models/wallet_model.dart';

part 'modify_transaction_screen_state.dart';

class ModifyTransactionScreenCubit extends Cubit<ModifyTransactionScreenState> {
  final int? transactionId;

  ModifyTransactionScreenCubit({TransactionModel? transaction})
      : transactionId = transaction?.id,
        super(ModifyTransactionScreenState(
        isEdit: transaction != null ? true : false,
        amount: transaction?.amount,
        wallet: transaction?.wallet,
        category: transaction?.category,
        selectedDate: transaction?.date ?? DateTime.now(),
        note: transaction?.note ?? '',
      ));

  void updateAmount(String text) {
    if (text.isEmpty) {
      emit(state.copyWith(amount: null, hasChange: true));
      return;
    }
    BigInt amount = BigInt.parse(text);
    emit(state.copyWith(amount: amount, hasChange: true));
  }

  void updateCategory(CategoryModel category) async {
    await Database().updateCategoryListFromFirestore();
    final updatedCategory = Database().categoryList.firstWhere((c) => c.id == category.id);
    emit(state.copyWith(category: updatedCategory, hasChange: true));
  }

  void updateWallet(WalletModel wallet) {
    emit(state.copyWith(wallet: wallet, hasChange: true));
  }

  void updateNote(String note) {
    emit(state.copyWith(note: note, hasChange: true));
  }

  void updateSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate, hasChange: true));
  }

  void updateCategoryList() async {
    await Database().updateCategoryListFromFirestore();
    emit(state.copyWith(categoryList: Database().categoryList));
  }

  void updateWalletList() {
    emit(state.copyWith(walletList: Database().walletList));
  }

  void updateStatus() {
    emit(state.copyWith(status: ExecuteStatus.waiting, dialogContent: ''));
  }

  bool _validate() {
    emit(state.copyWith(status: ExecuteStatus.executing, dialogContent: ''));
    if (state.amount == null) {
      emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: 'Amount is empty'));
      return false;
    }

    if (state.amount! <= BigInt.zero) {
      emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: 'Amount is invalid'));
      return false;
    }

    if (state.category == null) {
      emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: 'Choose a category'));
      return false;
    }

    if (state.wallet == null) {
      emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: 'Choose a wallet'));
      return false;
    }
    return true;
  }

  Future<void> addTransaction() async {
    if (_validate()) {
      try {
        await TransactionBUS.addTransactionToFirestore(
          TransactionModel(
            id: 0,
            amount: state.amount!,
            category: state.category!,
            note: state.note,
            date: state.selectedDate,
            wallet: state.wallet!,
          ),
        );
        emit(state.copyWith(status: ExecuteStatus.success, dialogContent: 'Add transaction successfully'));
      } catch (e) {
        emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: e.toString()));
      }
    }
  }

  Future<void> updateTransaction() async {
    if (_validate()) {
      try {
        await TransactionBUS.updateTransactionToFirestore(
          TransactionModel(
            id: transactionId!,
            amount: state.amount!,
            category: state.category!,
            note: state.note,
            date: state.selectedDate,
            wallet: state.wallet!,
          ),
        );
        emit(state.copyWith(status: ExecuteStatus.success, dialogContent: 'Edit transaction successfully'));
      } catch (e) {
        emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: e.toString()));
      }
    }
  }

  Future<void> deleteTransaction() async {
    try {
      await TransactionBUS.deleteTransactionFromFirestore(transactionId!);
      emit(state.copyWith(status: ExecuteStatus.success, dialogContent: 'Delete transaction successfully'));
    } catch (e) {
      emit(state.copyWith(status: ExecuteStatus.fail, dialogContent: e.toString()));
    }
  }
}