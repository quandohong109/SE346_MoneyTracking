import 'package:flutter/material.dart';

class WalletField extends StatelessWidget {
  final String text;
  final String hintText;
  final VoidCallback? onTap;
  final Icon prefixIcon;
  final Color textColor;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const WalletField({
    super.key,
    this.text = '',
    this.hintText = '',
    this.onTap,
    required this.prefixIcon,
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
          color: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
