import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_tracking/data/buses/transaction_bus.dart';
import 'package:money_tracking/data/database/database.dart';
import 'package:money_tracking/objects/models/transaction_model.dart';

import '../../../../objects/models/category_model.dart';

part 'add_screen_state.dart';

class AddScreenCubit extends Cubit<AddScreenState> {
  AddScreenCubit() : super(AddScreenState(selectedDate: DateTime.now()));

  void updateIsExpanded(bool isExpanded) {
    emit(state.copyWith(isExpanded: isExpanded));
  }

  void updateAmount(String text) {
    BigInt amount = BigInt.parse(text);
    emit(state.copyWith(amount: amount));
  }

  void updateCategory(CategoryModel category) {
    emit(state.copyWith(category: category));
  }

  void updateNote(String note) {
    emit(state.copyWith(note: note));
  }

  void updateSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(selectedDate: selectedDate));
  }

  void updateCategoryList() {
    Database().updateCategoryList();
    List<CategoryModel> categoryList = Database().categoryList;
    emit(state.copyWith(categoryList: categoryList));
  }

  void addTransaction(String name) {
    if (state.amount == null) {
      return;
    }

    if (state.category == null) {
      return;
    }

    TransactionModel transaction = TransactionModel(
      id: 0,
      amount: state.amount!,
      category: state.category!,
      note: state.note,
      date: state.selectedDate,
      wallet: Database().walletList[0],
      isExpanded: false,
    );

    TransactionBUS.addTransaction(transaction);
  }
}