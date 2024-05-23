import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/common/theme/app_colors.dart';

class AppTheme {
  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  AppTheme._internal();

  ThemeData getAppTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      cardTheme: Theme.of(context).cardTheme.copyWith(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                getCardCornerRadius(),
              ),
            ),
          ),
      textTheme: Theme.of(context).textTheme.copyWith(
            bodyMedium: TextStyle(
              fontSize: 14,
              color: AppColors.text,
            ),
          ),
    );
  }

  double getCardCornerRadius() {
    return 4;
  }
}
