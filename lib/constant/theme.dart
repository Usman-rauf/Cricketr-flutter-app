import 'package:cricketly/constant/colors.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class TextFieldDecoration {
  static BorderRadius get textBorderRadius => BorderRadius.circular(5);
  static Color get borderColor => ConstColors.boardColor;

  static Color get outLineInputBorderColor => ConstColors.boardColor;
  static double get borderWidth => 0.0;

  static const EdgeInsetsGeometry _contentPadding =
      EdgeInsets.only(left: 15, top: 10, bottom: 10);

  // UnderLine border...
  static InputDecorationTheme get getOutLineInputDecoration =>
      InputDecorationTheme(
        errorMaxLines: 2,
        filled: true,
        fillColor: ConstColors.whiteColorF9,
        focusColor: ConstColors.boardColor,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: ConstColors.black.withOpacity(0.5),
        ),
        // labelStyle: TextStyleDecoration.labelTextStyle,
        // errorStyle: TextStyleDecoration.errorStyle,

        // border: InputBorder.none,
        // focusedBorder: InputBorder.none,
        // enabledBorder: InputBorder.none,
        // errorBorder: InputBorder.none,
        // disabledBorder: InputBorder.none,
        // focusedErrorBorder: _outlineFocusedErrorBorder,
        errorBorder: _outlineFocusedErrorBorder,
        focusedBorder: _outlineFocusedBorder,
        border: _outlineBorder,
        enabledBorder: _outlineEnableBorder,
        disabledBorder: _outlineDisabledBorder,
        contentPadding: _contentPadding,
      );

  static OutlineInputBorder get _outlineDisabledBorder => OutlineInputBorder(
        borderRadius: textBorderRadius,
        borderSide: BorderSide(
          color: outLineInputBorderColor,
          width: borderWidth,
        ),
      );

  static OutlineInputBorder get _outlineFocusedBorder => OutlineInputBorder(
        borderRadius: textBorderRadius,
        borderSide: BorderSide(
          color: outLineInputBorderColor,
          width: borderWidth,
        ),
      );

  static OutlineInputBorder get _outlineEnableBorder => OutlineInputBorder(
        borderRadius: textBorderRadius,
        borderSide: BorderSide(
          color: outLineInputBorderColor,
          width: borderWidth,
        ),
      );
  static OutlineInputBorder get _outlineBorder => OutlineInputBorder(
        borderRadius: textBorderRadius,
        borderSide: BorderSide(
          color: outLineInputBorderColor,
          width: borderWidth,
        ),
      );

  static OutlineInputBorder get _outlineFocusedErrorBorder =>
      OutlineInputBorder(
        borderRadius: textBorderRadius,
        borderSide: BorderSide(
          color: outLineInputBorderColor,
          width: borderWidth,
        ),
      );
}
