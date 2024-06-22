part of 'edit_category_cubit.dart';

class EditCategoryDialogState with EquatableMixin {
  final bool isExpanded;
  final IconType iconSelected;
  final Color categoryColor;
  final bool isIncome;
  final bool hasChanged;

  const EditCategoryDialogState({
    this.isExpanded = false,
    required this.iconSelected,
    this.categoryColor = Colors.white,
    this.isIncome = false,
    this.hasChanged = false,
  });

  @override
  List<Object?> get props => [isExpanded, iconSelected, categoryColor, isIncome];

  EditCategoryDialogState copyWith({
    bool? isExpanded,
    IconType? iconSelected,
    Color? categoryColor,
    bool? isIncome,
    bool? hasChanged,
  }) {
    return EditCategoryDialogState(
      isExpanded: isExpanded ?? this.isExpanded,
      iconSelected: iconSelected ?? this.iconSelected,
      categoryColor: categoryColor ?? this.categoryColor,
      isIncome: isIncome ?? this.isIncome,
      hasChanged: hasChanged ?? this.hasChanged,
    );
  }
}
