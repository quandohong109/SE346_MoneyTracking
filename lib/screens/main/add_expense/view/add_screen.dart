import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/date_select_field.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/field_with_icon.dart';
import 'package:money_tracking/screens/main/add_expense/view/dialog/new_category_dialog.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/standard_button.dart';
import '../cubit/add_screen_cubit.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Thêm giao dịch mới',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 16,),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FieldWithIcon(
                  prefixIcon: const Icon(
                    FontAwesomeIcons.dollarSign,
                    size: 16,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32,),

              FieldWithIcon(
                hintText: 'Loại giao dịch',
                readOnly: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  FontAwesomeIcons.list,
                  size: 16,
                  color: Colors.grey,
                ),
                suffixIcon: const Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: Colors.grey,
                ),
                onSuffixIconPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return NewCategoryDialog.newInstance();
                      }
                  );
                },
              ),
              const SizedBox(height: 16,),

              BlocBuilder<AddScreenCubit, AddScreenState>(
                  builder: (context, state) {
                    return InkWell(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                      ),
                      onTap: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: state.selectedDate,
                          firstDate: DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          confirmText: 'Lưu',
                          cancelText: 'Hủy',
                        );
                        if (newDate != null){
                          cubit.updateSelectedDate(newDate);
                        }
                        else{
                          print("null");
                        }
                      },
                    );
                  }),
              const SizedBox(height: 32,),

              StandardButton(
                height: kToolbarHeight,
                onTap: () {},
                text: 'Lưu',
              ),
            ],
          ),
        ),
      ),
    );
  }
}