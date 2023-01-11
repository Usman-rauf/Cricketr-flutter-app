import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';

Future<void> showLoader(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          color: ConstColors.appGreen8FColor,
        ),
      );
    },
  );
}

void hideLoader(BuildContext context) => Navigator.of(context).pop();

class CommanCircular extends StatelessWidget {
  const CommanCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: ConstColors.appGreen8FColor,
      ),
    );
  }
}
