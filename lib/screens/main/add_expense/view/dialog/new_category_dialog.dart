import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/main/add_expense/entities/icon_types.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/dropdown_icon_container.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/standard_button.dart';

import '../../cubit/dialog/new_category_dialog_cubit.dart';
import 'color_picker_dialog.dart';

class NewCategoryDialog extends StatefulWidget {
  const NewCategoryDialog({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => NewCategoryDialogCubit(),
        child: const NewCategoryDialog(),
      );

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialog();
}

class _NewCategoryDialog extends State<NewCategoryDialog> {
  NewCategoryDialogCubit get cubit => context.read<NewCategoryDialogCubit>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Tạo loại giao dịch mới',
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: BlocBuilder<NewCategoryDialogCubit, NewCategoryDialogState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FieldWithIcon(
                        prefixIcon: Icon(state.iconSelected, size: 30,),
                        hintText: 'Tên loại giao dịch',
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
                        iconTypes: iconTypes,
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
                                  cubit.updateTypeSelected(0);
                                },
                                backgroundColor: state.typeSelected == 0
                                    ? Colors.red
                                    : Colors.grey,
                                text: 'Chi',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800,
                              )
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                              child: StandardButton(
                                height: kToolbarHeight * 0.8,
                                onTap: () {
                                  cubit.updateTypeSelected(1);
                                },
                                backgroundColor: state.typeSelected == 1
                                    ? Colors.green
                                    : Colors.grey,
                                text: 'Thu',
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
                      ),
                      const SizedBox(height: 24,),

                      StandardButton(
                        height: kToolbarHeight,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: 'Lưu',
                      )
                    ],
                  );
                }),
          )
      ),
    );
  }
}