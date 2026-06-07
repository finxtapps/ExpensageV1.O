import 'package:expensag/theme/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppThemes.themes['Teal']!;
  String _currentTheme = 'Teal';

  ThemeData get themeData => _themeData;
  String get currentTheme => _currentTheme;

  ThemeProvider(); // ✅ empty constructor

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('selectedTheme') ?? 'Teal';

    _themeData =
        AppThemes.themes[savedTheme] ?? AppThemes.themes['Teal']!;
    _currentTheme = savedTheme;
    notifyListeners();
  }

  Future<void> setTheme(String themeName) async {
    if (!AppThemes.themes.containsKey(themeName)) return;

    _themeData = AppThemes.themes[themeName]!;
    _currentTheme = themeName;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', themeName);
  }
}



