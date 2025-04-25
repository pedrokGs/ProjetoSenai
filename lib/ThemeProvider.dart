import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    ),
  );

  ThemeData get currentTheme => _currentTheme;

  void switchToKidsPalette() {
    _currentTheme = ThemeData(
      primaryColor: Colors.pink,
      scaffoldBackgroundColor: Colors.yellow[100],
      colorScheme: ColorScheme.light(
        primary: Colors.pink,
        secondary: Colors.orange,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.red, fontSize: 20),
        bodyMedium: TextStyle(color: Colors.blue, fontSize: 14),
      ),
    );
    notifyListeners();
  }

  void switchToNormalPalette() {
    _currentTheme = ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20),
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
    );
    notifyListeners();
  }
}
