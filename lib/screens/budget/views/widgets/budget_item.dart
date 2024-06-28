import 'package:flutter/material.dart';
import '../../../../../objects/models/category_model.dart';

class BudgetItem extends StatefulWidget {
  final CategoryModel category;
  final bool isChecked;
  final double amount;
  final Function(bool?) onCheckChanged;
  final Function(String) onAmountChanged;

  const BudgetItem({
    Key? key,
    required this.category,
    required this.isChecked,
    required this.amount,
    required this.onCheckChanged,
    required this.onAmountChanged,
  }) : super(key: key);

  @override
  _BudgetItemState createState() => _BudgetItemState();
}

class _BudgetItemState extends State<BudgetItem> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.amount.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(widget.category.getIcon(), color: widget.category.getColor()),
          SizedBox(width: 10),
          Text(widget.category.getName()),
        ],
      ),
      trailing: Container(
        width: 100,
        child: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Amount',
          ),
          onChanged: widget.onAmountChanged,
          enabled: widget.isChecked,
        ),
      ),
      tileColor: widget.isChecked ? Colors.grey[200] : null,
    );
  }
}
