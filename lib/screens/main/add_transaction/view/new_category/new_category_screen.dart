import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/dropdown_icon_container.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';

import '../../../../../data/database/database.dart';
import '../../cubit/new_category/new_category_cubit.dart';
import 'color_picker_dialog.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => NewCategoryDialogCubit(),
        child: const NewCategoryScreen(),
      );

  @override
  State<NewCategoryScreen> createState() => _NewCategoryDialog();
}

class _NewCategoryDialog extends State<NewCategoryScreen> {
  NewCategoryDialogCubit get cubit => context.read<NewCategoryDialogCubit>();

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
                'Tạo loại giao dịch mới',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 12,),

              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<NewCategoryDialogCubit, NewCategoryDialogState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FieldWithIcon(
                              prefixIcon: Icon(state.iconSelected.icon, size: 30,),
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
                                        cubit.updateIsIncome(true);
                                      },
                                      backgroundColor: state.isIncome
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
                            )
                          ],
                        );
                      }),
                ),
              ),
              const SizedBox(height: 12,),

              StandardButton(
                height: kToolbarHeight,
                onTap: () {
                  cubit.addCategory(nameController, context);
                  Navigator.pop(context);
                },
                text: 'Lưu',
              )
            ],
          ),
        )
    );
  }
}