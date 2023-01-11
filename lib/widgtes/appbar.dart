import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/constant/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

PreferredSizeWidget commanAppbar({
  required String appbarName,
}) {
  return AppBar(
    backgroundColor: ConstColors.appBlueColor,
    elevation: 0.0,
    centerTitle: true,
    title: Text(
      appbarName.toUpperCase(),
      style: const TextStyle(
        color: ConstColors.white,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    ),
  );
}

class CommanAppBar extends StatelessWidget {
  final String title;
  final void Function() onTap;
  const CommanAppBar({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SvgPicture.asset(
              ConstImages.backArrowImg,
              height: size.height * 0.03,
              color: ConstColors.black,
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: ConstColors.black,
            letterSpacing: 0.7,
            fontWeight: FontWeight.w600,
            fontSize: size.height * 0.03,
          ),
        ),
        SizedBox(
          width: size.width * 0.07,
        ),
      ],
    );
  }
}

class BuildAppBar extends StatelessWidget {
  final String title;
  final void Function() onTap;

  const BuildAppBar({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.03,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: ConstColors.whiteColorF9,
                border: Border.all(
                  color: ConstColors.boardColor,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(15),
              child: SvgPicture.asset(
                ConstImages.backArrowImg,
                color: ConstColors.black,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.05,
          ),
          Text(
            title,
            style: TextStyle(
              color: ConstColors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: size.width * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
