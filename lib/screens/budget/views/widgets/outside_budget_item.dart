import 'package:flutter/material.dart';

class OutsideBudgetItem extends StatelessWidget {
  final double amount;
  final Function(String) onAmountChanged;

  const OutsideBudgetItem({
    super.key,
    required this.amount,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _amountController = TextEditingController(text: amount.toString());

    return ListTile(
      title: Row(
        children: [
          Icon(Icons.miscellaneous_services, color: Colors.grey),
          SizedBox(width: 10),
          Text("Ngoài ngân sách"),
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
          onChanged: onAmountChanged,
        ),
      ),
      tileColor: Colors.grey[200],
    );
  }
}
