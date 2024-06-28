import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class TimeRangeSelection extends StatelessWidget {
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: months.length,
        itemBuilder: (context, index) {
          String month = months[index];
          return ListTile(
            title: Text(month),
            onTap: () {
              int monthIndex = index + 1;
              int year = DateTime.now().year;
              DateTime beginDay = DateTime(year, monthIndex, 1);
              DateTime endDay = DateTime(year, monthIndex + 1, 0);

              Navigator.pop(context, {
                'description': month,
                'begin': beginDay,
                'end': endDay,
              });
            },
          );
        },
      ),
    );
  }
}