import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'colors.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: HexColor('504c4b'),
  primarySwatch: defaultColor,
  appBarTheme: AppBarTheme(
    titleSpacing: 20,
    iconTheme: const IconThemeData(color: Colors.white, size: 27),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,

      fontWeight: FontWeight.bold,
    ),
    backwardsCompatibility: false,
    backgroundColor: HexColor('504c4b'),
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('504c4b'),
        statusBarIconBrightness: Brightness.light),
  ),
  textTheme:  const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      fontFamily: 'Times New Roman',
      color:Colors.white,
    ),
      subtitle1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Times New Roman',
          color: Colors.black,
          height: 1.0
      )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: HexColor('504c4b'),
  ),
);

ThemeData lightTheme = ThemeData(
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    titleSpacing: 20,
    iconTheme: IconThemeData(color: Colors.black, size: 27),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    backwardsCompatibility: false,
    backgroundColor: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark),
  ),
  textTheme:  const TextTheme(
    bodyText1: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        fontFamily: 'Times New Roman',
        color: Colors.black,
      ),
    subtitle1: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'Times New Roman',
      color: Colors.black,
      height: 1.3
    )
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
    backgroundColor: Colors.white,
  ),
);