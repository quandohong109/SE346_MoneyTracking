part of 'modify_transaction_screen_cubit.dart';

class ModifyTransactionScreenState with EquatableMixin {
  final BigInt? amount;
  final CategoryModel? category;
  final String note;
  final DateTime selectedDate;
  final List<CategoryModel> categoryList;
  final ExecuteStatus status;
  final String errorName;

  const ModifyTransactionScreenState({
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
        selectedDate,
        amount,
        category,
        note,
        categoryList,
        status,
        errorName
      ];

  ModifyTransactionScreenState copyWith({
    BigInt? amount,
    CategoryModel? category,
    String? note,
    DateTime? selectedDate,
    List<CategoryModel>? categoryList,
    ExecuteStatus? status,
    String? errorName
  }) {
    return ModifyTransactionScreenState(
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
