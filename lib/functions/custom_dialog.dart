import 'package:flutter/material.dart';
import 'package:money_tracking/screens/main/add_transaction/view/widgets/standard_button.dart';

class CustomDialog {
  static void showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: 120,
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            StandardButton(
              text: 'OK',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showConfirmDialog(BuildContext context, String title, String content, Function onYesPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: 120,
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: StandardButton(
                    text: 'Yes',
                    onTap: () {
                      onYesPressed();
                      Navigator.of(context).pop();
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: StandardButton(
                    text: 'No',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}