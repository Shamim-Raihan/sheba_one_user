import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData appTheme = ThemeData(
  primarySwatch: Colors.green,
  fontFamily: 'Poppins',
  appBarTheme: appBarTheme,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kScaffoldColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: inputDecorationTheme,
  elevatedButtonTheme: elevatedButtonThemeData,
);

AppBarTheme appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: kAppBackground,
  centerTitle: true,
  foregroundColor: Colors.black,
  titleTextStyle: const TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  filled: true,
  fillColor: kTextFieldBackground,
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
);

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      kPrimaryColor,
    ),
    foregroundColor: MaterialStateProperty.all<Color>(
      Colors.white,
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    ),
    elevation: MaterialStateProperty.all<double>(0),
  ),
);
