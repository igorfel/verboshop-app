import 'package:flutter/material.dart';

TextStyle textStyle = const TextStyle(
  color: const Color.fromRGBO(255, 255, 255, 1.0),
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);

ThemeData appTheme = new ThemeData(
    hintColor: Colors.white,
    brightness: Brightness.light,
    textSelectionColor: primaryColor,
    textSelectionHandleColor: primaryColor,
    primaryColor: Colors.red[900],
    accentColor: Colors.redAccent,
    cursorColor: Colors.redAccent);

Color textFieldColor = const Color.fromRGBO(255, 255, 255, 0.1);

Color primaryColor = const Color.fromRGBO(154, 41, 39, 1.0);
Color disabledPrimaryColor = const Color.fromRGBO(77, 30, 30, 0.8);

TextStyle buttonTextStyle = const TextStyle(
    color: const Color.fromRGBO(255, 255, 255, 0.8),
    fontSize: 14.0,
    fontFamily: "Roboto",
    fontWeight: FontWeight.bold);
