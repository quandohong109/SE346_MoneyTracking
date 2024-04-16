import 'package:flutter/material.dart';
import 'package:money_tracking/screens/main/add_expense/view/entities/icon_types.dart';

class FieldWithIcon extends StatelessWidget {
  final bool readOnly;
  final String hintText;
  final Color fillColor;
  final VoidCallback? onTap;
  final Icon? prefixIcon;
  final VoidCallback? onPrefixIconPressed;
  final Icon? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final OutlineInputBorder? border;

  const FieldWithIcon({
    super.key,
    this.readOnly = false,
    this.hintText = '',
    this.fillColor = Colors.white,
    this.onTap,
    this.prefixIcon,
    this.onPrefixIconPressed,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      onTap: onTap,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? InkWell(
          onTap: onPrefixIconPressed,
          child: prefixIcon,
        )
            : null,
        suffixIcon: suffixIcon != null ? InkWell(
          onTap: onSuffixIconPressed,
          child: suffixIcon,
        )
            : null,
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
