import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/objects/models/execute_status.dart';
import 'package:money_tracking/objects/models/icon_type.dart';

import '../../../../../data/buses/category_bus.dart';
import '../../../../../objects/models/category_model.dart';

part 'category_screen_state.dart';

class CategoryScreenDialogCubit extends Cubit<CategoryScreenDialogState> {
  final int? categoryId;

  CategoryScreenDialogCubit({CategoryModel? category})
      : categoryId = category?.id,
        super(CategoryScreenDialogState(
          isEdit: category != null ? true : false,
          name: category?.name ?? '',
          iconSelected: category?.iconType ??
              IconType(id: 0, icon: Icons.question_mark),
          categoryColor: category?.color ?? Colors.white,
          isIncome: category?.isIncome ?? false));

  void updateIsExpanded(bool isExpanded) {
    emit(state.copyWith(isExpanded: isExpanded));
  }

  void updateIconSelected(IconType iconSelected) {
    emit(state.copyWith(iconSelected: iconSelected, hasChange: true));
  }

  void updateCategoryColor(Color categoryColor) {
    emit(state.copyWith(categoryColor: categoryColor, hasChange: true));
  }

  void updateIsIncome(bool isIncome) {
    emit(state.copyWith(isIncome: isIncome, hasChange: true));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name, hasChange: true));
  }

  void updateStatus() {
    emit(state.copyWith(status: ExecuteStatus.waiting, errorName: ''));
  }

  bool _validate() {
    emit(state.copyWith(status: ExecuteStatus.executing, errorName: ''));
    if (state.name.isEmpty) {
      emit(state.copyWith(status: ExecuteStatus.fail, errorName: 'Name is empty'));
      return false;
    }

    if (state.iconSelected.id == 0) {
      emit(state.copyWith(status: ExecuteStatus.fail, errorName: 'Choose an icon'));
      return false;
    }
    return true;
  }

  Future<void> addCategory() async {
    if (_validate()) {
      try {
        await CategoryBUS.addCategoryToFirestore(
          CategoryModel(
            id: 0,
            name: state.name,
            iconType: state.iconSelected,
            color: state.categoryColor,
            isIncome: state.isIncome,
          ),
        ).then((_) {
          emit(state.copyWith(status: ExecuteStatus.success, errorName: ''));
        });
      } catch (e) {
        emit(state.copyWith(status: ExecuteStatus.fail, errorName: e.toString()));
      }
    }
  }

  Future<void> updateCategory() async {
    if (_validate()) {
      try {
        await CategoryBUS.editCategoryInFirestore(
            CategoryModel(
              id: categoryId!,
              name: state.name,
              iconType: state.iconSelected,
              color: state.categoryColor,
              isIncome: state.isIncome,
            )
        ).then((_) {
          emit(state.copyWith(status: ExecuteStatus.success, errorName: ''));
        });
      } catch (e) {
        emit(state.copyWith(status: ExecuteStatus.fail, errorName: e.toString()));
      }
    }
  }

  Future<void> deleteCategory() async {
    try {
      await CategoryBUS.deleteCategoryFromFirestore(categoryId!).then((_) {
        emit(state.copyWith(status: ExecuteStatus.success, errorName: ''));
      });
    } catch (e) {
      emit(state.copyWith(status: ExecuteStatus.fail, errorName: e.toString()));
    }
  }
}
