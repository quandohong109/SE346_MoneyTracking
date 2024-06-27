import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../objects/models/category_model.dart';
import '../view/widgets/budget_item.dart';
import '../view/widgets/outside_budget_item.dart';
import '../../../../../objects/models/icon_type.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
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

  void _pickMonthYear() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = selectedDate;
        int initialMonthIndex = selectedDate.month - 1;
        int initialYearIndex = selectedDate.year - 2000;

        return AlertDialog(
          title: Text("Select Month and Year"),
          content: Container(
            height: 150,
            child: Row(
              children: <Widget>[
                // Month picker (đặt ở vị trí bên trái)
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    physics: FixedExtentScrollPhysics(), // Giữ mục đã chọn ở giữa
                    onSelectedItemChanged: (index) {
                      tempPickedDate = DateTime(
                        tempPickedDate.year,
                        index + 1,
                      );
                    },
                    controller: FixedExtentScrollController(initialItem: initialMonthIndex),
                    children: List<Widget>.generate(12, (index) {
                      return Center(
                        child: Text(
                          DateFormat.MMMM().format(DateTime(0, index + 1)),
                          style: TextStyle(fontSize: 18.0), // Cải thiện độ dễ nhìn
                        ),
                      );
                    }),
                  ),
                ),
                // Year picker (đặt ở vị trí bên phải)
                Expanded(
                  child: ListWheelScrollView(
                    itemExtent: 50,
                    physics: FixedExtentScrollPhysics(), // Giữ mục đã chọn ở giữa
                    onSelectedItemChanged: (index) {
                      tempPickedDate = DateTime(
                        index + 2000,
                        tempPickedDate.month,
                      );
                    },
                    controller: FixedExtentScrollController(initialItem: initialYearIndex),
                    children: List<Widget>.generate(101, (index) {
                      return Center(
                        child: Text(
                          '${index + 2000}',
                          style: TextStyle(fontSize: 18.0), // Cải thiện độ dễ nhìn
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(tempPickedDate);
              },
            ),
          ],
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
                    _showBudgetDialog(selectedCategories);
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


  void _showBudgetDialog(List<CategoryModel> selectedCategories) {
    TextEditingController budgetController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nhập ngân sách cho tháng ${DateFormat.yMMM().format(selectedDate)}'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Nhập số tiền ngân sách"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentMonthBudget = double.tryParse(budgetController.text);
                  if (currentMonthBudget != null) {
                    // Thiết lập ngân sách cho từng danh mục đã chọn
                    selectedCategories.forEach((category) {
                      monthlyBudgets[DateFormat.yMMM().format(selectedDate)] = currentMonthBudget!;
                    });
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
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
        title: Text('NGÂN SÁCH'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MonthPicker(
            selectedDate: selectedDate,
            onNext: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
                currentMonthBudget = monthlyBudgets[DateFormat.yMMM().format(selectedDate)];
              });
            },
            onPrevious: () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                currentMonthBudget = monthlyBudgets[DateFormat.yMMM().format(selectedDate)];
              });
            },
            onPick: _pickMonthYear,
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

class MonthPicker extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onPick;

  const MonthPicker({
    Key? key,
    required this.selectedDate,
    required this.onNext,
    required this.onPrevious,
    required this.onPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left),
          onPressed: onPrevious,
        ),
        Column(
          children: List<Widget>.generate(3, (index) {
            int displayMonth = selectedDate.month - 1 + index - 1;
            return Opacity(
              opacity: index == 1 ? 1.0 : 0.5,
              child: TextButton(
                onPressed: index == 1 ? onPick : null,
                child: Text(
                  DateFormat.yMMM().format(DateTime(selectedDate.year, displayMonth + 1)),
                  style: TextStyle(fontWeight: index == 1 ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            );
          }),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right),
          onPressed: onNext,
        ),
      ],
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
