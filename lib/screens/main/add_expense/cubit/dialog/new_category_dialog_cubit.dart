import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'new_category_dialog_state.dart';

class NewCategoryDialogCubit extends Cubit<NewCategoryDialogState> {
  NewCategoryDialogCubit() : super(const NewCategoryDialogState(iconSelected: Icons.question_mark));

  void updateIsExpanded(bool isExpanded) {
    emit(state.copyWith(isExpanded: isExpanded));
  }

  void updateIconSelected(IconData iconSelected) {
    emit(state.copyWith(iconSelected: iconSelected));
  }

  void updateCategoryColor(Color categoryColor) {
    emit(state.copyWith(categoryColor: categoryColor));
  }

  void updateTypeSelected(int typeSelected) {
    emit(state.copyWith(typeSelected: typeSelected));
  }
}