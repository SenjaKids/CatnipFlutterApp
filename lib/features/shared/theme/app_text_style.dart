import 'package:flutter/material.dart';

class AppTextStyle {
  final Color color;
  AppTextStyle({required this.color});

  TextStyle mulishTitleXXL() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: color,
      );
  TextStyle mulishTitleXL() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.24,
        color: color,
      );
  TextStyle mulishTitleL() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
      );
  TextStyle mulishTitleM() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.16,
        color: color,
      );
  TextStyle mulishBodyM() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.16,
        color: color,
      );
  TextStyle mulishBodyS() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.14,
        color: color,
        // height: 1.5,
      );
  TextStyle mulishBodyXS() => TextStyle(
        fontFamily: 'Mulish',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.12,
        color: color,
      );

  TextStyle sfproBodyS() => TextStyle(
        fontFamily: 'SF-Pro',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );
  TextStyle sfproBodyXS() => TextStyle(
        fontFamily: 'SF-Pro',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );
  TextStyle sfproBodyL() => TextStyle(
        fontFamily: 'SF-Pro',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.18,
        color: color,
      );
}
