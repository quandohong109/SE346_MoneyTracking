import 'package:equatable/equatable.dart';
import 'package:money_tracking/objects/models/category_model.dart';
import '../../../objects/models/transaction_model.dart';

class TransactionScreenState with EquatableMixin {
  final DateTime selectedDate;
  final Stream<List<TransactionModel>> transactionListStream;
  final List<TransactionModel> filteredTransactions;

  const TransactionScreenState({
    required this.selectedDate,
    this.transactionListStream = const Stream.empty(),
    this.filteredTransactions = const [],
  });

  @override
  List<Object?> get props => [selectedDate, transactionListStream, filteredTransactions];

  TransactionScreenState copyWith({
    DateTime? selectedDate,
    Stream<List<TransactionModel>>? transactionListStream,
    List<TransactionModel>? filteredTransactions,
  }) {
    return TransactionScreenState(
      selectedDate: selectedDate ?? this.selectedDate,
      transactionListStream: transactionListStream ?? this.transactionListStream,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
    );
  }
}
