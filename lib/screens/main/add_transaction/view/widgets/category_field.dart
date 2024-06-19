import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryField extends StatelessWidget {
  final String text;
  final String hintText;
  final VoidCallback? onTap;
  final Icon prefixIcon;
  final VoidCallback? onSuffixIconPressed;
  final Color fillColor;
  final Color textColor;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const CategoryField({
    super.key,
    this.text = '',
    this.hintText = '',
    this.onTap,
    required this.prefixIcon,
    this.onSuffixIconPressed,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: borderRadius ?? BorderRadius.circular(15.0),
        ),

        child: Row(
          children: [
            prefixIcon,
            const SizedBox(width: 14),

            Expanded(
              child: Text(
                text.isEmpty ? hintText : text,
                style: TextStyle(
                    color: text.isEmpty ? Colors.grey : textColor,
                    fontSize: 20
                ),
              ),
            ),

            InkWell(
              onTap: onSuffixIconPressed,
              child: const Icon(
                FontAwesomeIcons.plus,
                size: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
