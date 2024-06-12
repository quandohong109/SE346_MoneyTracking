import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking/objects/models/icon_type.dart';

import '../../../../../data/buses/category_bus.dart';
import '../../../../../objects/models/category_model.dart';

part 'new_category_state.dart';

class NewCategoryDialogCubit extends Cubit<NewCategoryDialogState> {
  NewCategoryDialogCubit() : super(NewCategoryDialogState(
      iconSelected: IconType(id: 0, icon: Icons.question_mark)
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

  void updateTypeSelected(int typeSelected) {
    emit(state.copyWith(typeSelected: typeSelected));
  }

  void addCategory(TextEditingController nameController, BuildContext context) {
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

    CategoryBUS.addCategory(
      CategoryModel(
        id: DateTime
            .now()
            .millisecondsSinceEpoch,
        name: nameController.text,
        iconType: state.iconSelected,
        color: state.categoryColor,
        type: state.typeSelected,
      ),
    );
  }
}