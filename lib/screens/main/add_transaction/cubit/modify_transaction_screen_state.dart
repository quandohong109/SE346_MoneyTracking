part of 'modify_transaction_screen_cubit.dart';

class ModifyTransactionScreenState with EquatableMixin {
  final BigInt? amount;
  final CategoryModel? category;
  final WalletModel? wallet;
  final String note;
  final DateTime selectedDate;
  final List<CategoryModel> categoryList;
  final List<WalletModel> walletList;
  final ExecuteStatus status;
  final String dialogContent;
  final bool isEdit;
  final bool hasChange;

  const ModifyTransactionScreenState({
    this.amount,
    this.category,
    this.wallet,
    this.note = '',
    required this.selectedDate,
    this.categoryList = const [],
    this.walletList = const [],
    this.status = ExecuteStatus.waiting,
    this.dialogContent = '',
    this.isEdit = false,
    this.hasChange = false
  });

  @override
  List<Object?> get props =>
      [
        selectedDate,
        amount,
        category,
        wallet,
        note,
        categoryList,
        walletList,
        status,
        dialogContent,
        isEdit,
        hasChange
      ];

  ModifyTransactionScreenState copyWith({
    BigInt? amount,
    CategoryModel? category,
    WalletModel? wallet,
    String? note,
    DateTime? selectedDate,
    List<CategoryModel>? categoryList,
    List<WalletModel>? walletList,
    ExecuteStatus? status,
    String? dialogContent,
    bool? isEdit,
    bool? hasChange,
  }) {
    return ModifyTransactionScreenState(
        amount: amount ?? this.amount,
        category: category ?? this.category,
        wallet: wallet ?? this.wallet,
        note: note ?? this.note,
        selectedDate: selectedDate ?? this.selectedDate,
        categoryList: categoryList ?? this.categoryList,
        walletList: walletList ?? this.walletList,
        status: status ?? this.status,
        dialogContent: dialogContent ?? this.dialogContent,
        isEdit: isEdit ?? this.isEdit,
        hasChange: hasChange ?? this.hasChange
    );
  }
}
