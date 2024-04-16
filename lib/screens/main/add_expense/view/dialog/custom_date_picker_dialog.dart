import 'package:flutter/material.dart';
import 'package:money_tracking/screens/main/add_expense/view/widgets/standard_button.dart';

class CustomDatePickerDialog extends StatelessWidget {
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;

  const CustomDatePickerDialog({
    super.key,
    required this.onDateChanged,
    required this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarDatePicker(
              initialDate: initialDate,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateChanged: onDateChanged,
            ),
            StandardButton(
              onTap: () => Navigator.pop(context),
              text: 'Lưu',
            )
          ],
        ),
      ),
    );
  }
}