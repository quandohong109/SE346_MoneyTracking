part of 'category_screen_cubit.dart';

class CategoryScreenState with EquatableMixin {
  final IconType iconSelected;
  final Color categoryColor;
  final bool isIncome;
  final ExecuteStatus status;
  final String dialogContent;
  final String name;
  final bool isEdit;
  final bool hasChange;

  const CategoryScreenState({
    required this.iconSelected,
    this.categoryColor = Colors.white,
    this.isIncome = false,
    this.status = ExecuteStatus.waiting,
    this.hasChange = false,
    this.name = '',
    this.dialogContent = '',
    this.isEdit = false
  });

  @override
  List<Object?> get props =>
      [
        status,
        dialogContent,
        name,
        iconSelected,
        categoryColor,
        isIncome,
        isEdit,
        hasChange
      ];

  CategoryScreenState copyWith({
    IconType? iconSelected,
    Color? categoryColor,
    bool? isIncome,
    ExecuteStatus? status,
    bool? isEdit,
    bool? hasChange,
    String? dialogContent,
    String? name
  }) {
    return CategoryScreenState(
        iconSelected: iconSelected ?? this.iconSelected,
        categoryColor: categoryColor ?? this.categoryColor,
        isIncome: isIncome ?? this.isIncome,
        status: status ?? this.status,
        dialogContent: dialogContent ?? this.dialogContent,
        isEdit: isEdit ?? this.isEdit,
        hasChange: hasChange ?? this.hasChange,
        name: name ?? this.name);
  }
}
