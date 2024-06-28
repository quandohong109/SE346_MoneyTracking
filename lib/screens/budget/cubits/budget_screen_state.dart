import 'package:equatable/equatable.dart';
import 'package:money_tracking/objects/models/budget_model.dart';

class BudgetScreenState with EquatableMixin {
  final DateTime startOfMonth;
  final DateTime endOfMonth;
  final Stream<List<BudgetModel>> budgetListStream;

  const BudgetScreenState({
    required this.startOfMonth,
    required this.endOfMonth,
    this.budgetListStream = const Stream.empty(),
  });

  @override
  List<Object?> get props => [startOfMonth, endOfMonth, budgetListStream];

  BudgetScreenState copyWith({
    DateTime? startOfMonth,
    DateTime? endOfMonth,
    Stream<List<BudgetModel>>? budgetListStream,
  }) {
    return BudgetScreenState(
      startOfMonth: startOfMonth ?? this.startOfMonth,
      endOfMonth: endOfMonth ?? this.endOfMonth,
      budgetListStream: budgetListStream ?? this.budgetListStream,
    );
  }
}
