import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/objects/models/icon_type.dart';

import '../../../../../data/buses/category_bus.dart';
import '../../../../../objects/models/category_model.dart';

part 'edit_category_state.dart';

class EditCategoryDialogCubit extends Cubit<EditCategoryDialogState> {
  final CategoryModel category;

  EditCategoryDialogCubit(this.category) : super(EditCategoryDialogState(
      iconSelected: category.iconType,
      categoryColor: category.color,
      isIncome: category.isIncome
  ));

  void updateIsExpanded(bool isExpanded) {
    emit(state.copyWith(isExpanded: isExpanded));
  }

  void updateIconSelected(IconType iconSelected) {
    emit(state.copyWith(iconSelected: iconSelected));
  }

  void updateCategoryColor(Color categoryColor) {
    emit(state.copyWith(categoryColor: categoryColor));
  }

  void updateIsIncome(bool isIncome) {
    emit(state.copyWith(isIncome: isIncome));
  }

  void editCategory(TextEditingController nameController, BuildContext context) {
    if (nameController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (_) =>
          const AlertDialog(
            title: Text('Lỗi'),
            content: Text('Tên không được để trống'),
          )
      );
      return;
    }

    if (state.iconSelected.id == 0) {
      showDialog(
          context: context,
          builder: (_) =>
          const AlertDialog(
            title: Text('Lỗi'),
            content: Text('Chưa chọn icon'),
          )
      );
      return;
    }

    CategoryBUS.editCategoryInFirestore(
      CategoryModel(
        id: category.id,
        name: nameController.text,
        iconType: state.iconSelected,
        color: state.categoryColor,
        isIncome: state.isIncome,
      ),
    );
  }

  void deleteCategory() {
    CategoryBUS.deleteCategoryFromFirestore(category.id);
  }
}