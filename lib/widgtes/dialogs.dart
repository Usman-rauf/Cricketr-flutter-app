import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showCommanDialogs({
  required BuildContext context,
  required String message,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Alert!'),
        content: Text(
          message,
          style: const TextStyle(color: ConstColors.black),
        ),
        actions: [
          MaterialButton2(
            onPressed: () {
              Navigator.pop(context);
            },
            buttonText: 'OK',
          )
        ],
      );
    },
  );
}

showTostMessage({required String message}) {
  Fluttertoast.showToast(msg: message);
}
