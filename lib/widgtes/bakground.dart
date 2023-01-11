import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';

class CommanBackGround extends StatelessWidget {
  const CommanBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ConstColors.darkBlue,
            ConstColors.backgroundColor,
            ConstColors.lightGreen62,
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
