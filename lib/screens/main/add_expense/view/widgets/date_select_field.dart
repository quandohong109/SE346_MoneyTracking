import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DateSelectField extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final VoidCallback? onTap;
  final OutlineInputBorder? border;
  final String initialValue;

  const DateSelectField({
    super.key,
    this.hintText = '',
    this.fillColor = Colors.white,
    this.onTap,
    this.border,
    this.initialValue = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      initialValue: initialValue,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: const Icon(
          FontAwesomeIcons.calendar,
          size: 16,
          color: Colors.grey,
        ),
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
