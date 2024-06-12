import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateSelectField extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color fillColor;
  final double width;
  final double height;

  const DateSelectField({
    super.key,
    required this.text,
    this.onTap,
    this.fillColor = Colors.white,
    this.width = double.infinity,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: [
            const Icon(
              FontAwesomeIcons.calendar,
              size: 20,
              color: Colors.black,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

