import 'package:flutter/material.dart';

import 'constants.dart' as constants;

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    primaryColor: constants.ColorsConstant.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: Colors.black,
    )),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      headline2: TextStyle(
        fontSize: 35,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      headline3: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      headline4: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      headline5: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      headline6: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
      subtitle1: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontFamily: constants.AppConstants.secondaryFont,
      ),
      subtitle2: TextStyle(
        fontSize: 13,
        color: Colors.black,
        fontFamily: constants.AppConstants.primaryFont,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 24.0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      errorMaxLines: 3,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: constants.ColorsConstant.primaryColor),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
    ),
  );
}
