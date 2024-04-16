part of 'add_screen_cubit.dart';

class AddScreenState with EquatableMixin {
  final DateTime selectedDate;

  const AddScreenState({
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [selectedDate];

  AddScreenState copyWith({
    DateTime? selectedDate,}) {
    return AddScreenState(
      selectedDate: this.selectedDate,
    );
  }
}
