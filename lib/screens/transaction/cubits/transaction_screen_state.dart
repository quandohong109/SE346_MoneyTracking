import 'package:equatable/equatable.dart';

import '../../../objects/models/category_model.dart';
import '../../../objects/models/transaction_model.dart';

class TransactionScreenState with EquatableMixin {
  final List<TransactionModel> transactionList;

  const TransactionScreenState({
    this.transactionList = const [],
  });

  @override
  List<Object?> get props => [transactionList];

  TransactionScreenState copyWith({
    List<TransactionModel>? transactionList,
  }) {
    return TransactionScreenState(
      transactionList: transactionList ?? this.transactionList,
    );
  }
}