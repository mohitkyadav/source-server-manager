import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static const Color yellow = Color.fromRGBO(251, 194, 55, 0.9);

  static const Color white = Color.fromRGBO(250, 250, 250, 1);
  static const Color white60 = Color.fromRGBO(250, 250, 250, 0.6);
  static const Color white20 = Color.fromRGBO(250, 250, 250, 0.2);
  static const Color white40 = Color.fromRGBO(250, 250, 250, 0.4);
  static const Color white80 = Color.fromRGBO(250, 250, 250, 0.8);

  static const Color green = Color.fromRGBO(122, 248, 122, 1);
  static const Color green20 = Color.fromRGBO(122, 248, 122, 0.2);
  static const Color green40 = Color.fromRGBO(122, 248, 122, 0.4);
  static const Color green60 = Color.fromRGBO(122, 248, 122, 0.6);
  static const Color green80 = Color.fromRGBO(122, 248, 122, 0.8);

  static const Color red = Color.fromRGBO(252, 68, 69, 1);
  static const Color red20 = Color.fromRGBO(252, 68, 69, 0.2);
  static const Color red40 = Color.fromRGBO(252, 68, 69, 0.4);
  static const Color red60 = Color.fromRGBO(252, 68, 69, 0.6);

  static const Color blackShadowOp15 = Color.fromRGBO(0, 0, 0, 0.15);
  static const Color blackShadowOp20 = Color.fromRGBO(0, 0, 0, 0.20);
  static const Color blackShadowOp30 = Color.fromRGBO(0, 0, 0, 0.30);
  static const Color blackShadowOp50 = Color.fromRGBO(0, 0, 0, 0.50);
  static const Color blackShadowOp70 = Color.fromRGBO(0, 0, 0, 0.70);

  static const Color lightPurple = Color.fromRGBO(114, 137, 218, 1);
  static const Color lightGray = Color.fromRGBO(153, 170, 181, 1);
  static const Color darkGray = Color.fromRGBO(44, 47, 51, 1);
  static const Color black = Color.fromRGBO(35, 39, 42, 1);

  static const Color blue = Color.fromRGBO(95, 151, 250, 1);
  static const Color charcoalGrey = Color.fromRGBO(50, 50, 59, 1);

  static const BoxShadow blockShadow = BoxShadow(
      color: blackShadowOp30,
      offset: Offset(0, 3),
      blurRadius: 8,
      spreadRadius: 0
  );

  static const BoxShadow blockShadow1 = BoxShadow(
      color: Color(0x33000000),
      offset: Offset(0,20),
      blurRadius: 30,
      spreadRadius: 0
  );

  static const TextStyle textH1 = TextStyle(
    fontSize: 36,
  );

  static const TextStyle textH2 = TextStyle(
    fontSize: 28,
  );

  static const TextStyle addServerHeader = TextStyle(
    fontSize: 18,
    letterSpacing: 2,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle playerItemTitle = TextStyle(
    color:  white,
    fontWeight: FontWeight.w600,
    fontStyle:  FontStyle.normal,
    fontSize: 18.0
  );

  static const TextStyle serverItemTitle = TextStyle(
    color:  white,
    fontWeight: FontWeight.w600,
    fontStyle:  FontStyle.normal,
    fontSize: 16.0
  );

  static const TextStyle serverItemSubTitle = TextStyle(
    color:  Colors.white70,
    fontWeight: FontWeight.w400,
    fontStyle:  FontStyle.normal,
    fontSize: 14.0
  );

  static const TextStyle serverDetailsHeaderTitle = TextStyle(
    color:  white,
    fontWeight: FontWeight.w600,
    fontStyle:  FontStyle.normal,
    fontSize: 20.0,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 10,
        color: black,
      ),
    ],
  );

  static const TextStyle serverDetailsHeaderSubTitle = TextStyle(
    color:  white,
    fontWeight: FontWeight.w600,
    fontStyle:  FontStyle.normal,
    fontSize: 18.0,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 10,
        color: black,
      ),
    ],
  );
}

