
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/category_model.dart';

part 'filter_screen_state.dart';

class FilterScreenCubit extends Cubit<FilterScreenState> {
  FilterScreenCubit() : super(FilterScreenState(selectedDate: DateTime.now()));

  void updateIsExpanded(bool isExpanded) {
    emit(state.copyWith(isExpanded: isExpanded));
  }

  void updateAmount(String text) {
    double amount = double.parse(text);
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
}