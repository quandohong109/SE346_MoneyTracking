part of 'new_category_cubit.dart';

class NewCategoryDialogState with EquatableMixin {
  final bool isExpanded;
  final IconType iconSelected;
  final Color categoryColor;
  final bool isIncome;

  const NewCategoryDialogState({
    this.isExpanded = false,
    required this.iconSelected,
    this.categoryColor = Colors.white,
    this.isIncome = false,
  });

  @override
  List<Object?> get props => [isExpanded, iconSelected, categoryColor, isIncome];

  NewCategoryDialogState copyWith({
    bool? isExpanded,
    IconType? iconSelected,
    Color? categoryColor,
    bool? isIncome,
  }) {
    return NewCategoryDialogState(
      isExpanded: isExpanded ?? this.isExpanded,
      iconSelected: iconSelected ?? this.iconSelected,
      categoryColor: categoryColor ?? this.categoryColor,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}
