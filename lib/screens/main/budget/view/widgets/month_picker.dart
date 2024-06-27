import 'package:flutter/material.dart';

class MonthPicker extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onPick;

  const MonthPicker({
    super.key,
    required this.selectedDate,
    required this.onNext,
    required this.onPrevious,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: onPrevious,
          ),
          InkWell(
            onTap: onPick,
            child: Text(
              "${selectedDate.month}/${selectedDate.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
