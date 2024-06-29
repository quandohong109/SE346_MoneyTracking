import 'package:bloc/bloc.dart';
import 'package:money_tracking/screens/stat/views/cubits/stat_screen_state.dart';

import '../../../../data/database/database.dart';
import '../../../../objects/models/category_model.dart';
import '../../../../objects/models/transaction_model.dart';

class StatScreenCubit extends Cubit<StatScreenState> {
  StatScreenCubit() : super(
      StatScreenState(
        selectedDate: DateTime.now(),
        beginDate: DateTime(DateTime.now().year, DateTime.now().month),
        endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ));

  void updateTransactionListStream() async {
    await Database().updateTransactionListStream();
    emit(state.copyWith(
      transactionListStream: Database().transactionListStream,
    ));
  }

  void updateSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(
      selectedDate: selectedDate,
      beginDate: DateTime(selectedDate.year, selectedDate.month),
      endDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
    ));
  }

  void calculateIncomeAndExpense(List<TransactionModel> transactionList) {
    List<CategoryModel> incomeCategoryList = [];
    List<CategoryModel> expenseCategoryList = [];
    double income = 0;
    double expense = 0;

    for (var element in transactionList) {
      if (element.date.compareTo(getEndDate()) <= 0) {
        if (!element.category.isIncome) {
          if (element.date.compareTo(getStartDate()) >= 0) {
            expense += element.amount.toDouble();
            if (!expenseCategoryList.any((categoryElement) => categoryElement.name == element.category.name)) {
              expenseCategoryList.add(element.category);
            }
          }
        } else if (element.category.isIncome) {
          if (element.date.compareTo(getStartDate()) >= 0) {
            income += element.amount.toDouble();
            if (!incomeCategoryList.any((categoryElement) => categoryElement.name == element.category.name)) {
              incomeCategoryList.add(element.category);
            }
          }
        }
      }
    }
    emit(state.copyWith(
      income: income,
      expense: expense,
      transactionList: transactionList,
      incomeCategoryList: incomeCategoryList,
      expenseCategoryList: expenseCategoryList,
    ));
  }

  DateTime getStartDate() {
    return DateTime(state.selectedDate.year, state.selectedDate.month);
  }

  DateTime getEndDate() {
    return DateTime(state.selectedDate.year, state.selectedDate.month + 1, 0);
  }
}