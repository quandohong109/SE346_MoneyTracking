import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/functions/custom_dialog.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/dropdown_icon_container.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';

import '../../../../../data/database/database.dart';
import '../../../../../objects/models/execute_status.dart';
import '../../cubit/category/category_screen_cubit.dart';
import 'color_picker_dialog.dart';
import '../../../../../objects/models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => CategoryScreenCubit(),
        child: const CategoryScreen(),
      );

  static Widget newInstanceWithCategory({required CategoryModel category}) =>
      BlocProvider(
        create: (context) => CategoryScreenCubit(category: category),
        child: const CategoryScreen(),
      );

  @override
  State<CategoryScreen> createState() => _CategoryScreen();
}

class _CategoryScreen extends State<CategoryScreen> {
  CategoryScreenCubit get cubit => context.read<CategoryScreenCubit>();
  TextEditingController nameController = TextEditingController();
  ValueNotifier<bool> isExpandedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    isExpandedNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<CategoryScreenCubit, CategoryScreenState>(
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
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<CategoryScreenCubit, CategoryScreenState>(
                      builder: (context, state) {
                        return Text(
                          state.isEdit ? 'Edit' : 'New category',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: BlocBuilder<CategoryScreenCubit, CategoryScreenState>(
                            builder: (context, state) {
                              if (state.name.isNotEmpty) {
                                nameController.text = state.name;
                              }
                              return ValueListenableBuilder<bool>(
                                valueListenable: isExpandedNotifier,
                                builder: (context, value, child) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FieldWithIcon(
                                        prefixIcon: Icon(
                                          state.iconSelected.icon,
                                          size: 30,
                                        ),
                                        hintText: 'Name',
                                        controller: nameController,
                                        onPrefixIconPressed: () {
                                          isExpandedNotifier.value = !isExpandedNotifier.value;
                                        },
                                        border: OutlineInputBorder(
                                          borderRadius: isExpandedNotifier.value
                                              ? const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          )
                                              : BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        fillColor: state.categoryColor,
                                        onChange: (text) {
                                          cubit.updateName(text);
                                        },
                                      ),
                                      DropdownIconContainer(
                                        isExpanded: isExpandedNotifier.value,
                                        selectedIcon: state.iconSelected,
                                        iconTypes: Database().iconTypeList,
                                        onIconSelected: (icon) {
                                          cubit.updateIconSelected(icon);
                                          isExpandedNotifier.value = false;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: StandardButton(
                                                height: kToolbarHeight * 0.8,
                                                onTap: () {
                                                  cubit.updateIsIncome(false);
                                                },
                                                backgroundColor:
                                                state.isIncome ? Colors.grey : Colors.red,
                                                text: 'Expense',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w800,
                                              )),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: StandardButton(
                                                height: kToolbarHeight * 0.8,
                                                onTap: () {
                                                  cubit.updateIsIncome(true);
                                                },
                                                backgroundColor:
                                                state.isIncome ? Colors.green : Colors.grey,
                                                text: 'Income',
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w800,
                                              )),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Container(
                                                height: kToolbarHeight * 0.8,
                                                decoration: BoxDecoration(
                                                  color: state.categoryColor,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.color_lens,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx2) {
                                                        return ColorPickerDialog(
                                                          onColorChanged: (value) {
                                                            cubit.updateCategoryColor(value);
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              )),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            }),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    BlocBuilder<CategoryScreenCubit, CategoryScreenState>(
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
                                          'Are you sure you want to edit this category?',
                                              () async {
                                            await cubit.updateCategory();
                                          }
                                      );
                                    } else {
                                      await cubit.addCategory();
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
                                      'Are you sure you want to delete this category?',
                                          () async {
                                        await cubit.deleteCategory();
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
              )
          ),
        )
    );
  }
}
