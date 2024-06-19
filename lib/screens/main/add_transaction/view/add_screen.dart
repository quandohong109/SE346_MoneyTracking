import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking/data/database/database.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/category_field.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/category_list_container.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/date_select_field.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/new_category/new_category_screen.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/multi_field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';
import '../../../../objects/models/category_model.dart';
import '../cubit/add_screen_cubit.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => AddScreenCubit(),
        child: const AddScreen(),
      );

  @override
  State<AddScreen> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  AddScreenCubit get cubit => context.read<AddScreenCubit>();

  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.updateCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      {
        FocusScope.of(context).unfocus(),
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
              const Text(
                'New transaction',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 12,),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FieldWithIcon(
                        hintText: 'Amount',
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        onSubmitted: (String amount) {
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
                      ),
                      const SizedBox(height: 20,),

                      BlocBuilder<AddScreenCubit, AddScreenState>(
                          buildWhen: (previous, current) =>
                          (
                              previous.isExpanded != current.isExpanded
                                  || previous.category != current.category
                          ),
                          builder: (context, state) {
                            return Column(
                              children: [
                                CategoryField(
                                  text: state.category?.getName() ?? '',
                                  hintText: 'Category',
                                  onTap: () {
                                    cubit.updateIsExpanded(!state.isExpanded);
                                  },
                                  fillColor: state.category?.getColor() ?? Colors.white,
                                  borderRadius: state.isExpanded
                                      ? const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  )
                                      : BorderRadius.circular(15.0),
                                  prefixIcon: Icon(
                                    state.category?.getIcon() ?? FontAwesomeIcons.list,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  onSuffixIconPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => NewCategoryScreen.newInstance(),
                                        )
                                    );
                                  },
                                ),

                                CategoryListContainer(
                                  isExpanded: state.isExpanded,
                                  categories: Database().categoryList,
                                  onCategoryTap: (CategoryModel category) {
                                    cubit.updateCategory(category);
                                  },
                                )
                              ],
                            );
                          }),

                      const SizedBox(height: 20,),
                      BlocBuilder<AddScreenCubit, AddScreenState>(
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

                      MultiFieldWithIcon(
                        hintText: 'Note',
                        controller: noteController,
                        prefixIcon: const Icon(
                          FontAwesomeIcons.pencil,
                          size: 20,
                          color: Colors.black,
                        ),
                        onSubmitted: (String text) {
                          cubit.updateNote(text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12,),

              StandardButton(
                height: kToolbarHeight,
                onTap: () {
                  cubit.addTransaction();
                  Navigator.pop(context);
                },
                text: 'Add transaction',
              ),
            ],
          ),
        ),
      ),
    );
  }
}