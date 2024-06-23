part of 'add_screen_cubit.dart';

class AddScreenState with EquatableMixin {
  final bool isExpanded;
  final BigInt? amount;
  final CategoryModel? category;
  final String note;
  final DateTime selectedDate;
  final List<CategoryModel> categoryList;
  final ExecuteStatus status;
  final String errorName;

  const AddScreenState({
    this.isExpanded = false,
    this.amount,
    this.category,
    this.note = '',
    required this.selectedDate,
    this.categoryList = const [],
    this.status = ExecuteStatus.waiting,
    this.errorName = '',
  });

  @override
  List<Object?> get props =>
      [
        isExpanded,
        selectedDate,
        amount,
        category,
        note,
        categoryList,
        status,
        errorName
      ];

  AddScreenState copyWith({
    bool? isExpanded,
    BigInt? amount,
    CategoryModel? category,
    String? note,
    DateTime? selectedDate,
    List<CategoryModel>? categoryList,
    ExecuteStatus? status,
    String? errorName
  }) {
    return AddScreenState(
      isExpanded: isExpanded ?? this.isExpanded,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      selectedDate: selectedDate ?? this.selectedDate,
      categoryList: categoryList ?? this.categoryList,
      status: status ?? this.status,
      errorName: errorName ?? this.errorName,
    );
  }
}
