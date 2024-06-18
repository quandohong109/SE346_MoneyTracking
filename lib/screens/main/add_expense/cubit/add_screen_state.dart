part of 'add_screen_cubit.dart';

class AddScreenState with EquatableMixin {
  final bool isExpanded;
  final double? amount;
  final CategoryModel? category;
  final String note;
  final DateTime selectedDate;
  final List<CategoryModel> categoryList;

  const AddScreenState({
    this.isExpanded = false,
    this.amount,
    this.category,
    this.note = '',
    required this.selectedDate,
    this.categoryList = const [],
  });

  @override
  List<Object?> get props => [isExpanded, selectedDate, amount, category, note, categoryList];

  AddScreenState copyWith({
    bool? isExpanded,
    double? amount,
    CategoryModel? category,
    String? note,
    DateTime? selectedDate,
    List<CategoryModel>? categoryList,
  }) {
    return AddScreenState(
      isExpanded: isExpanded ?? this.isExpanded,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      selectedDate: selectedDate ?? this.selectedDate,
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
