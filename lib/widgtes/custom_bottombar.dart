library custom_line_indicator_bottom_navbar;

import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum IndicatorType { Top, Bottom }

class CustomLineIndicatorBottomNavbar extends StatelessWidget {
  final Color? backgroundColor;
  final List<CustomBottomBarItems> customBottomBarItems;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unselectedFontSize;
  final Color? splashColor;
  final int currentIndex;
  final bool enableLineIndicator;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;
  final Function(int) onTap;
  final double selectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;
  final LinearGradient? gradient;

  const CustomLineIndicatorBottomNavbar({
    this.backgroundColor,
    this.selectedColor,
    required this.customBottomBarItems,
    this.unSelectedColor,
    this.unselectedFontSize = 12,
    this.selectedFontSize = 12,
    this.selectedIconSize = 25,
    this.unselectedIconSize = 25,
    this.splashColor,
    this.currentIndex = 0,
    required this.onTap,
    this.enableLineIndicator = true,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.Top,
    this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? bottomTheme.backgroundColor,
        gradient: gradient,
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < customBottomBarItems.length; i++) ...[
              Expanded(
                child: CustomLineIndicatorBottomNavbarItems(
                  selectedColor: selectedColor,
                  unSelectedColor: unSelectedColor,
                  icon: customBottomBarItems[i].icon,
                  label: customBottomBarItems[i].label,
                  unSelectedFontSize: unselectedFontSize,
                  selectedFontSize: selectedFontSize,
                  unselectedIconSize: unselectedIconSize,
                  selectedIconSize: selectedIconSize,
                  splashColor: splashColor,
                  currentIndex: currentIndex,
                  enableLineIndicator: enableLineIndicator,
                  lineIndicatorWidth: lineIndicatorWidth,
                  indicatorType: indicatorType,
                  index: i,
                  onTap: onTap,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class CustomBottomBarItems {
  final String icon;
  final String label;

  CustomBottomBarItems({
    required this.icon,
    required this.label,
  });
}

class CustomLineIndicatorBottomNavbarItems extends StatelessWidget {
  final String icon;
  final String? label;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unSelectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;

  final double selectedFontSize;
  final Color? splashColor;
  final int? currentIndex;
  final int index;
  final Function(int) onTap;
  final bool enableLineIndicator;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;

  const CustomLineIndicatorBottomNavbarItems({
    required this.icon,
    this.label,
    this.selectedColor,
    this.unSelectedColor,
    this.unSelectedFontSize = 12,
    this.selectedFontSize = 12,
    this.selectedIconSize = 20,
    this.unselectedIconSize = 20,
    this.splashColor,
    this.currentIndex,
    required this.onTap,
    required this.index,
    this.enableLineIndicator = true,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.Top,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            onTap(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? selectedColor ?? bottomTheme.unselectedItemColor
                  : unSelectedColor,
              border: enableLineIndicator
                  ? Border(
                      bottom: indicatorType == IndicatorType.Bottom
                          ? BorderSide(
                              color: currentIndex == index
                                  ? selectedColor ??
                                      bottomTheme.selectedItemColor!
                                  : Colors.transparent,
                              width: lineIndicatorWidth,
                            )
                          : const BorderSide(color: Colors.transparent),
                      top: indicatorType == IndicatorType.Top
                          ? BorderSide(
                              color: currentIndex == index
                                  ? selectedColor ??
                                      bottomTheme.selectedItemColor ??
                                      Colors.black
                                  : Colors.transparent,
                              width: lineIndicatorWidth,
                            )
                          : const BorderSide(color: Colors.transparent),
                    )
                  : null,
            ),
            // padding: const EdgeInsets.symmetric(vertical: 7.0),
            // width: 70,
            // height: 60,
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                SvgPicture.asset(
                  icon,
                  height: currentIndex == index
                      ? selectedIconSize
                      : unselectedIconSize,
                  color: currentIndex == index
                      ? ConstColors.white
                      : ConstColors.black,
                ),
                // Icon(
                //   icon,
                //   size: currentIndex == index
                //       ? selectedIconSize
                //       : unselectedIconSize,
                //   color: currentIndex == index
                //       ? selectedColor ?? bottomTheme.unselectedItemColor
                //       : unSelectedColor,
                // ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  '$label',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: currentIndex == index
                        ? selectedFontSize
                        : unSelectedFontSize,
                    color: currentIndex == index
                        ? selectedColor ?? bottomTheme.unselectedItemColor
                        : unSelectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
