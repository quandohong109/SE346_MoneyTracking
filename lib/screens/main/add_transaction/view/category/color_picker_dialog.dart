import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';

class ColorPickerDialog extends StatelessWidget {
  final Function(Color) onColorChanged;

  const ColorPickerDialog({
    super.key,
    required this.onColorChanged
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              pickerColor: Colors.white,
              onColorChanged: onColorChanged,
            ),
            StandardButton(
              onTap: () => Navigator.pop(context),
              text: 'Save',
            )
          ],
        ),
      ),
    );
  }
}