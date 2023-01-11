import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';

class CommanButton extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final double? minWidth;
  const CommanButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: minWidth,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.all(12),
      color: ConstColors.ofwhite,
      child: Text(
        buttonText,
        style: const TextStyle(
          color: ConstColors.white,
          letterSpacing: 0.7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MaterialButton2 extends StatelessWidget {
  final String buttonText;
  final void Function() onPressed;
  final double? minWidth;
  const MaterialButton2({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0CAB65),
              Color(0xff3BB78F),
              Color(0xff3BB78F),
            ],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: minWidth,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(12),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: ConstColors.white,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
