import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static const yellow = Color.fromRGBO(251, 194, 55, 0.9);

  static const white = Color.fromRGBO(250, 250, 250, 1);
  static const white60 = Color.fromRGBO(250, 250, 250, 0.6);
  static const white20 = Color.fromRGBO(250, 250, 250, 0.2);
  static const white40 = Color.fromRGBO(250, 250, 250, 0.4);
  static const white80 = Color.fromRGBO(250, 250, 250, 0.8);

  static const green = Color.fromRGBO(122, 248, 122, 1);
  static const green20 = Color.fromRGBO(122, 248, 122, 0.2);
  static const green40 = Color.fromRGBO(122, 248, 122, 0.4);
  static const green60 = Color.fromRGBO(122, 248, 122, 0.6);
  static const green80 = Color.fromRGBO(122, 248, 122, 0.8);

  static const red = Color.fromRGBO(252, 68, 69, 1);
  static const red20 = Color.fromRGBO(252, 68, 69, 0.2);
  static const red40 = Color.fromRGBO(252, 68, 69, 0.4);
  static const red60 = Color.fromRGBO(252, 68, 69, 0.6);

  static const blackShadowOp15 = Color.fromRGBO(0, 0, 0, 0.15);
  static const blackShadowOp20 = Color.fromRGBO(0, 0, 0, 0.20);
  static const blackShadowOp30 = Color.fromRGBO(0, 0, 0, 0.30);
  static const blackShadowOp70 = Color.fromRGBO(0, 0, 0, 0.70);

  static const lightPurple = Color.fromRGBO(114, 137, 218, 1);
  static const lightGray = Color.fromRGBO(153, 170, 181, 1);
  static const darkGray = Color.fromRGBO(44, 47, 51, 1);
  static const black = Color.fromRGBO(35, 39, 42, 1);

  static const blockShadow = BoxShadow(
      color: blackShadowOp30,
      offset: Offset(0, 3),
      blurRadius: 8,
      spreadRadius: 0
  );

  static const blockShadow1 = BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0,20),
      blurRadius: 30,
      spreadRadius: 0
  );

  static const textH1 = TextStyle(
    fontSize: 36,
  );
}

