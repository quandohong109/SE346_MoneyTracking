part of 'add_screen_cubit.dart';

class AddScreenState with EquatableMixin {
  final bool isExpanded;
  final double? amount;
  final CategoryModel? category;
  final String note;
  final DateTime selectedDate;

  const AddScreenState({
    this.isExpanded = false,
    this.amount,
    this.category,
    this.note = '',
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [isExpanded, selectedDate, amount, category, note];

  AddScreenState copyWith({
    bool? isExpanded,
    double? amount,
    CategoryModel? category,
    String? note,
    DateTime? selectedDate,
  }) {
    return AddScreenState(
      isExpanded: isExpanded ?? this.isExpanded,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
