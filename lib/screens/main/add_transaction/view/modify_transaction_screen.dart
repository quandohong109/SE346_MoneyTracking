import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking/data/database/database.dart';
import 'package:money_tracking/objects/models/wallet_model.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/category_field.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/category_list_container.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/date_select_field.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/category/category_screen.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/multi_field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/wallet_field.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/wallet_list_container.dart';
import '../../../../functions/custom_dialog.dart';
import '../../../../objects/models/category_model.dart';
import '../../../../objects/models/execute_status.dart';
import '../../../../objects/models/transaction_model.dart';
import '../cubit/modify_transaction_screen_cubit.dart';
import 'package:intl/intl.dart';

class ModifyTransactionScreen extends StatefulWidget {
  const ModifyTransactionScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => ModifyTransactionScreenCubit(),
        child: const ModifyTransactionScreen(),
      );

  static Widget newInstanceWithTransaction({required TransactionModel transaction}) =>
      BlocProvider(
        create: (context) => ModifyTransactionScreenCubit(transaction: transaction),
        child: const ModifyTransactionScreen(),
      );

  @override
  State<ModifyTransactionScreen> createState() => _ModifyTransactionScreen();
}

class _ModifyTransactionScreen extends State<ModifyTransactionScreen> {
  ModifyTransactionScreenCubit get cubit => context.read<ModifyTransactionScreenCubit>();

  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  ValueNotifier<bool> isCategoryExpandedNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> isWalletExpandedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    Database().updateWalletListFromFirestore();
    cubit.updateCategoryList();
    cubit.updateWalletList();
    isCategoryExpandedNotifier = ValueNotifier<bool>(false);
    isWalletExpandedNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
          listenWhen: (previous, current) =>
          previous.status != current.status && (current.status == ExecuteStatus.fail || current.status == ExecuteStatus.success),
          listener: (context, state) {
            if (state.status == ExecuteStatus.success) {
              Navigator.of(context).pop();
              CustomDialog.showInfoDialog(context, 'Success', state.dialogContent);
              cubit.updateStatus();
            } else if (state.status == ExecuteStatus.fail) {
              CustomDialog.showInfoDialog(context, 'Error', state.dialogContent);
              cubit.updateStatus();
            }
          },
          child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            appBar: AppBar(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .background,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                    builder: (context, state) {
                      return Text(
                        state.isEdit ? 'Edit' : 'New transaction',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                  const SizedBox(height: 12,),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                                builder: (context, state) {
                                  if (state.amount != null) {
                                    amountController.text = state.amount.toString();
                                  }
                                  return FieldWithIcon(
                                    hintText: 'Amount',
                                    controller: amountController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                    ],
                                    onSubmitted: (amount) {
                                      cubit.updateAmount(amount);
                                    },
                                    onChange: (amount) {
                                      cubit.updateAmount(amount);
                                    },
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.dollarSign,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  );
                                }),
                            const SizedBox(height: 20,),

                            BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                                buildWhen: (previous, current) =>
                                (
                                    previous.category != current.category || previous.categoryList != current.categoryList
                                ),
                                builder: (context, state) {
                                  return ValueListenableBuilder(
                                    valueListenable: isCategoryExpandedNotifier,
                                    builder: (context, isCategoryExpanded, child) {
                                      return Column(
                                        children: [
                                          CategoryField(
                                            text: state.category?.getName() ?? '',
                                            hintText: 'Category',
                                            onTap: () {
                                              isCategoryExpandedNotifier.value = !isCategoryExpandedNotifier.value;
                                            },
                                            fillColor: state.category?.getColor() ?? Colors.white,
                                            borderRadius: isCategoryExpanded
                                                ? const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            )
                                                : BorderRadius.circular(15.0),
                                            prefixIcon: Icon(
                                              state.category?.getIcon() ?? FontAwesomeIcons.list,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            onSuffixIconPressed: () async {
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder: (BuildContext context) => CategoryScreen.newInstance(),
                                                  )
                                              );
                                              cubit.updateCategoryList();
                                            },
                                          ),

                                          CategoryListContainer(
                                            isExpanded: isCategoryExpanded,
                                            categories: state.categoryList,
                                            onCategoryTap: (CategoryModel category) {
                                              cubit.updateCategory(category);
                                              isCategoryExpandedNotifier.value = false;
                                            },
                                            onEditTap: () => cubit.updateCategoryList(),
                                          )
                                        ],
                                      );},
                                  );
                                }),
                            const SizedBox(height: 20,),

                            BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                                buildWhen: (previous, current) =>
                                (
                                    previous.wallet != current.wallet || previous.walletList != current.walletList
                                ),
                                builder: (context, state) {
                                  return ValueListenableBuilder(
                                    valueListenable: isWalletExpandedNotifier,
                                    builder: (context, isWalletExpanded, child) {
                                      return Column(
                                        children: [
                                          WalletField(
                                            text: state.wallet?.getName() ?? '',
                                            hintText: 'Wallet',
                                            onTap: () {
                                              isWalletExpandedNotifier.value = !isWalletExpandedNotifier.value;
                                            },
                                            borderRadius: isWalletExpanded
                                                ? const BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            )
                                                : BorderRadius.circular(15.0),
                                            prefixIcon: const Icon(
                                              FontAwesomeIcons.wallet,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                          ),

                                          WalletListContainer(
                                            isExpanded: isWalletExpanded,
                                            wallets: state.walletList,
                                            onWalletTap: (WalletModel wallet) {
                                              cubit.updateWallet(wallet);
                                              isWalletExpandedNotifier.value = false;
                                            },
                                            onEditTap: () => cubit.updateCategoryList(),
                                          )
                                        ],
                                      );},
                                  );
                                }),
                            const SizedBox(height: 20,),

                            BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                                buildWhen: (previous, current) =>
                                (
                                    previous.selectedDate != current.selectedDate
                                ),
                                builder: (context, state) {
                                  return DateSelectField(
                                    text: DateFormat('dd/MM/yyyy').format(state.selectedDate),
                                    onTap: () async {
                                      final DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: state.selectedDate,
                                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                        confirmText: 'Select',
                                        cancelText: 'Cancel',
                                        helpText: 'Date',
                                      );
                                      if (newDate != null){
                                        cubit.updateSelectedDate(newDate);
                                      }
                                    },
                                  );
                                }),
                            const SizedBox(height: 20,),

                            BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                                builder: (context, state) {
                                  if (state.note.isNotEmpty) {
                                    noteController.text = state.note;
                                  }
                                  return MultiFieldWithIcon(
                                    hintText: 'Note',
                                    controller: noteController,
                                    onChange: (text) {
                                      cubit.updateNote(text);
                                    },
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.pencil,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                    onSubmitted: (String text) {
                                      cubit.updateNote(text);
                                    },
                                  );
                                }
                            )
                          ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 12,),

                  BlocBuilder<ModifyTransactionScreenCubit, ModifyTransactionScreenState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: StandardButton(
                              height: kToolbarHeight,
                              onTap: () async {
                                if (state.hasChange) {
                                  if (state.isEdit) {
                                    CustomDialog.showConfirmDialog(
                                        context,
                                        'Confirm',
                                        'Are you sure you want to edit this transaction?',
                                            () async {
                                          await cubit.updateTransaction();
                                        }
                                    );
                                  } else {
                                    await cubit.addTransaction();
                                  }
                                }
                              },
                              text: 'Save',
                              backgroundColor: state.hasChange
                                  ? Theme
                                  .of(context)
                                  .colorScheme
                                  .primary
                                  : Colors.grey,
                            ),
                          ),
                          if (state.isEdit) ...[
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: StandardButton(
                                height: kToolbarHeight,
                                onTap: () {
                                  CustomDialog.showConfirmDialog(
                                    context,
                                    'Confirm',
                                    'Are you sure you want to delete this transaction?',
                                        () async {
                                      await cubit.deleteTransaction();
                                    },
                                  );
                                },
                                text: 'Delete',
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}