part of 'category_screen_cubit.dart';

class CategoryScreenState with EquatableMixin {
  final bool isExpanded;
  final IconType iconSelected;
  final Color categoryColor;
  final bool isIncome;
  final ExecuteStatus status;
  final String errorName;
  final String name;
  final bool isEdit;
  final bool hasChange;

  const CategoryScreenState({this.isExpanded = false,
    required this.iconSelected,
    this.categoryColor = Colors.white,
    this.isIncome = false,
    this.status = ExecuteStatus.fail,
    this.hasChange = false,
    this.name = '',
    this.errorName = '',
    this.isEdit = false});

  @override
  List<Object?> get props =>
      [
        status,
        errorName,
        name,
        isExpanded,
        iconSelected,
        categoryColor,
        isIncome,
        isEdit,
        hasChange
      ];

  CategoryScreenState copyWith({
    bool? isExpanded,
    IconType? iconSelected,
    Color? categoryColor,
    bool? isIncome,
    ExecuteStatus? status,
    bool? isEdit,
    bool? hasChange,
    String? errorName,
    String? name
  }) {
    return CategoryScreenState(
        isExpanded: isExpanded ?? this.isExpanded,
        iconSelected: iconSelected ?? this.iconSelected,
        categoryColor: categoryColor ?? this.categoryColor,
        isIncome: isIncome ?? this.isIncome,
        status: status ?? this.status,
        errorName: errorName ?? this.errorName,
        isEdit: isEdit ?? this.isEdit,
        hasChange: hasChange ?? this.hasChange,
        name: name ?? this.name);
  }
}
