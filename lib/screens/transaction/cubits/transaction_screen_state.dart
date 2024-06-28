import 'package:equatable/equatable.dart';
import '../../../objects/models/transaction_model.dart';

class TransactionScreenState with EquatableMixin {
  final DateTime startOfMonth;
  final DateTime endOfMonth;
  final Stream<List<TransactionModel>> transactionListStream;

  const TransactionScreenState({
    required this.startOfMonth,
    required this.endOfMonth,
    this.transactionListStream = const Stream.empty(),
  });

  @override
  List<Object?> get props => [startOfMonth, endOfMonth, transactionListStream];

  TransactionScreenState copyWith({
    DateTime? startOfMonth,
    DateTime? endOfMonth,
    Stream<List<TransactionModel>>? transactionListStream,
  }) {
    return TransactionScreenState(
      startOfMonth: startOfMonth ?? this.startOfMonth,
      endOfMonth: endOfMonth ?? this.endOfMonth,
      transactionListStream: transactionListStream ?? this.transactionListStream,
    );
  }
}
