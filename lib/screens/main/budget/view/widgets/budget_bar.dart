import 'package:flutter/material.dart';

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
            'Tháng ${DateTime.now().month} - ${totalBudget.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[300],
                ),
              ),
              Container(
                height: 20,
                width: spent > totalBudget
                    ? MediaQuery.of(context).size.width
                    : (spent / totalBudget) * MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: spent > totalBudget ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Đã chi: ${spent.toStringAsFixed(0)}',
            style: TextStyle(
              color: spent > totalBudget ? Colors.red : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
