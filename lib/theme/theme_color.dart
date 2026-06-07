import 'package:flutter/material.dart';

class AppThemes {
  static final pinkTheme = ThemeData(
    primaryColor: const Color(0xFFE16472),
    hintColor: const Color(0xFFE16472),
    focusColor:  Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE16472),
      secondary: Color(0xFFD44D5C),
    ),
  );

  static final blueTheme = ThemeData(
    primaryColor: Colors.blue,
    hintColor: Colors.lightBlueAccent,
    focusColor:  Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade200,
      secondary: Colors.lightBlueAccent,
    ),
  );

  static final tealTheme = ThemeData(
    primaryColor: Color(0xFF429690),
    hintColor: Color(0xFF537774),
    focusColor:  Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(

      primary: Color(0xFF429690),
      secondary: Color(0xFF2A7C76),
    ),
  );

  static final orangeTheme = ThemeData(
    primaryColor: Colors.orange,
    hintColor: Colors.deepOrangeAccent,
    focusColor:  Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.orange.shade200,
      secondary: Colors.deepOrangeAccent,
    ),
  );

  static final darkTheme = ThemeData(
    hintColor: Color(0xFF343030),
    primaryColor: const Color(0xFF000000),
    focusColor:  Color(0xFFE16472),
    scaffoldBackgroundColor: const Color(0xFF221F1F),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF000000),
      secondary: Color(0xFF343030),
    ),
  );

  static final themes = {
    'Pink': pinkTheme,
    'Blue': blueTheme,
    'Teal': tealTheme,
    'Orange': orangeTheme,
    'Dark': darkTheme,
  };
}
