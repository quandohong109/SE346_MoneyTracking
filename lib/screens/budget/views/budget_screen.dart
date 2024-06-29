import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../objects/models/category_model.dart';
import '../../main/month_picker.dart';
import '../cubits/budget_screen_cubit.dart';
import 'widgets/budget_item.dart';
import '../../../../../objects/models/icon_type.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => BudgetScreenCubit(),
        child: const BudgetScreen(),
      );

  @override
  State<BudgetScreen> createState() => _BudgetScreen();
}

class _BudgetScreen extends State<BudgetScreen> {
  BudgetScreenCubit get cubit => context.read<BudgetScreenCubit>();

  DateTime selectedDate = DateTime.now();
  double? currentMonthBudget;
  List<CategoryModel> categories = [
    CategoryModel(
      id: 1,
      name: 'Ăn uống',
      iconType: IconType(id: 1, icon: Icons.fastfood),
      isIncome: false,
      color: Colors.blue,
    ),
    CategoryModel(
      id: 2,
      name: 'Du lịch',
      iconType: IconType(id: 2, icon: Icons.travel_explore),
      isIncome: false,
      color: Colors.green,
    ),
  ];

  List<bool> isChecked = [false, false];
  List<double> amounts = [0.0, 0.0];
  double outsideAmount = 0.0;

  Map<String, double> monthlyBudgets = {};

  @override
  void initState() {
    super.initState();
    // Adding default category "Khác" (Other)
    categories.add(
      CategoryModel(
        id: 3,
        name: 'Khác',
        iconType: IconType(id: 3, icon: Icons.category),
        isIncome: false,
        color: Colors.grey,
      ),
    );
    // Initialize isChecked and amounts for default category
    isChecked.insert(2, true);
    amounts.insert(0, 0.0);
  }

  void _addBudget() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Chọn category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: categories.map((category) {
                  int index = categories.indexOf(category);
                  return CheckboxListTile(
                    title: Text(category.name),
                    value: isChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked[index] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    List<CategoryModel> selectedCategories = [];
                    for (int i = 0; i < categories.length; i++) {
                      if (isChecked[i]) {
                        selectedCategories.add(categories[i]);
                      }
                    }

                    // Ensure 'Khác' (Other) is checked by default if no other category is selected
                    if (selectedCategories.isEmpty) {
                      isChecked[0] = true; // 'Khác' category index
                      selectedCategories.add(categories[0]); // Add 'Khác' category to selected list
                    }

                    // Chỉ gọi _showBudgetDialog một lần với danh sách đã chọn
                    //_showBudgetDialog(selectedCategories);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double getTotalSpent() {
    return amounts.reduce((a, b) => a + b) + outsideAmount;
  }

  @override
  Widget build(BuildContext context) {
    double totalBudget = currentMonthBudget ?? 0.0;
    double totalSpent = getTotalSpent();

    // Filter categories based on isChecked
    List<CategoryModel> visibleCategories = [];
    for (int i = 0; i < categories.length; i++) {
      if (isChecked[i]) {
        visibleCategories.add(categories[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGÂN SÁCH'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MonthPicker(
            selectedDate: selectedDate,
            //onPick: _pickMonthYear,
            updateSelectedDate: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
                currentMonthBudget = monthlyBudgets[DateFormat.yMMM().format(selectedDate)];
              });
            },
          ),
          if (currentMonthBudget == null) ...[
            Center(
              child: ElevatedButton(
                onPressed: _addBudget,
                child: Text("Thêm ngân sách"),
              ),
            ),
          ] else ...[
              BudgetBar(totalBudget: totalBudget, spent: totalSpent),
              Expanded(
                child: ListView.builder(
                  itemCount: visibleCategories.length,
                  itemBuilder: (context, index) {
                    int originalIndex = categories.indexOf(visibleCategories[index]);
                    return BudgetItem(
                      key: ValueKey(visibleCategories[index].id), // Use a unique key for each item
                      category: visibleCategories[index],
                      isChecked: isChecked[originalIndex],
                      amount: amounts[originalIndex],
                      onCheckChanged: (value) {
                        setState(() {
                          isChecked[originalIndex] = value ?? false;
                        });
                      },
                      onAmountChanged: (value) {
                        setState(() {
                          amounts[originalIndex] = double.tryParse(value) ?? 0.0;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
        ],
      ),
    );
  }
}

class BudgetBar extends StatelessWidget {
  final double totalBudget;
  final double spent;

  BudgetBar({required this.totalBudget, required this.spent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tháng ${DateTime.now().month}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[300],
            value: spent / totalBudget,
            valueColor: AlwaysStoppedAnimation<Color>(
              spent > totalBudget ? Colors.red : Colors.blue,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Đã chi: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(spent)}'),
              Text('Ngân sách: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(totalBudget)}'),
            ],
          ),
        ],
      ),
    );
  }
}
