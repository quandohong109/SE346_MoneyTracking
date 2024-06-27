import 'package:bloc/bloc.dart';

import '../../../data/database/database.dart';
import 'budget_screen_state.dart';

class BudgetScreenCubit extends Cubit<BudgetScreenState> {
  BudgetScreenCubit() : super(
      BudgetScreenState(
        startOfMonth: DateTime(DateTime.now().year, DateTime.now().month),
        endOfMonth: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ));

  void updateBudgetListStream() {
    Database().updateBudgetListStream();
    emit(state.copyWith(budgetListStream: Database().budgetListStream));
  }
}