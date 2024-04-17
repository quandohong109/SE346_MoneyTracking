part of 'new_category_dialog_cubit.dart';

class NewCategoryDialogState with EquatableMixin {
  final bool isExpanded;
  final IconData iconSelected;
  final Color categoryColor;
  final int typeSelected;

  const NewCategoryDialogState({
    this.isExpanded = false,
    required this.iconSelected,
    this.categoryColor = Colors.white,
    this.typeSelected = 0,
  });

  @override
  List<Object?> get props => [isExpanded, iconSelected, categoryColor, typeSelected];

  NewCategoryDialogState copyWith({
    bool? isExpanded,
    IconData? iconSelected,
    Color? categoryColor,
    int? typeSelected,
  }) {
    return NewCategoryDialogState(
      isExpanded: isExpanded ?? this.isExpanded,
      iconSelected: iconSelected ?? this.iconSelected,
      categoryColor: categoryColor ?? this.categoryColor,
      typeSelected: typeSelected ?? this.typeSelected,
    );
  }
}
