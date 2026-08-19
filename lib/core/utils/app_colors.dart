import 'package:flutter/material.dart';

class AppColor{

  static const Color black = Color(0xFF000000);
  static const Color primary = Color(0xFFC4FE01);
  static const Color bgColor = Color(0xFF101010);



  static const Color gold = Color(0xFFFFA31A);
  static const Color darkText = Color(0xFF212427);
  static const Color usRed = Color(0xFFBF0D3E);
  static const Color usBlue = Color(0xFF041E42);
  static const Color yellow = Color(0xFFFEE440);
  static const Color subText2  = Color(0xFF606A8C);
  static const Color heartRed  = Color(0xFFEF104D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF1DBF73);
  static const Color darkGray = Color(0xFF4F4F4F);
  static const Color middleGray = Color(0xFF828282);
  static const Color lightGray = Color(0xFFC4C4C4);
  static  Gradient primaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC1EAFF), Color(0xFFBFDBE8).withValues(alpha: 0.075)
    ],);
}