import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/dropdown_icon_container.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';

import '../../../../../data/database/database.dart';
import '../../../../../objects/models/category_model.dart';
import '../../cubit/category/edit_category_cubit.dart';
import 'color_picker_dialog.dart';

class EditCategoryScreen extends StatefulWidget {
  final CategoryModel category;

  const EditCategoryScreen({super.key, required this.category});

  static Widget newInstance(CategoryModel category) =>
      BlocProvider(
        create: (context) => EditCategoryDialogCubit(category),
        child: EditCategoryScreen(category: category),
      );

  @override
  State<EditCategoryScreen> createState() => _EditCategoryDialog();
}

class _EditCategoryDialog extends State<EditCategoryScreen> {
  EditCategoryDialogCubit get cubit => context.read<EditCategoryDialogCubit>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Edit category',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 12,),

              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<EditCategoryDialogCubit, EditCategoryDialogState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FieldWithIcon(
                              prefixIcon: Icon(state.iconSelected.icon, size: 30,),
                              hintText: 'Name',
                              controller: nameController,
                              onPrefixIconPressed: () {
                                cubit.updateIsExpanded(!state.isExpanded);
                              },
                              border: OutlineInputBorder(
                                borderRadius: state.isExpanded
                                    ? const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                )
                                    : BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: state.categoryColor,
                            ),

                            DropdownIconContainer(
                              isExpanded: state.isExpanded,
                              selectedIcon: state.iconSelected,
                              iconTypes: Database().iconTypeList,
                              onIconSelected: (icon) {
                                cubit.updateIconSelected(icon);
                              },
                            ),
                            const SizedBox(height: 16,),

                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: StandardButton(
                                      height: kToolbarHeight * 0.8,
                                      onTap: () {
                                        cubit.updateIsIncome(false);
                                      },
                                      backgroundColor: state.isIncome
                                          ? Colors.grey
                                          : Colors.red,
                                      text: 'Expense',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                    )
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                    child: StandardButton(
                                      height: kToolbarHeight * 0.8,
                                      onTap: () {
                                        cubit.updateIsIncome(true);
                                      },
                                      backgroundColor: state.isIncome
                                          ? Colors.green
                                          : Colors.grey,
                                      text: 'Income',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                    )
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                    child: Container(
                                      height: kToolbarHeight * 0.8,
                                      decoration: BoxDecoration(
                                        color: state.categoryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.color_lens, size: 30,),
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
                                    )
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                ),
              ),
              const SizedBox(height: 12,),

              Row(
                children: [
                  BlocBuilder<EditCategoryDialogCubit, EditCategoryDialogState>(
                    builder: (context, state) {
                      return StandardButton(
                        height: kToolbarHeight,
                        onTap: state.hasChanged ? () {
                          cubit.editCategory(nameController, context);
                          Navigator.pop(context);
                        } : () {},
                        text: 'Save',
                        backgroundColor: state.hasChanged
                            ? Theme
                            .of(context)
                            .colorScheme
                            .primary
                            : Colors.grey,
                      );
                    },
                  ),

                  StandardButton(
                    height: kToolbarHeight,
                    onTap: () {
                      cubit.editCategory(nameController, context);
                      Navigator.pop(context);
                    },
                    text: 'Delete',
                    backgroundColor: Colors.red,
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}