import 'dart:ui';

import 'package:stockbuddy_flutter_app/common/theme/color_constants.dart';

class AppColors {
  AppColors._();

  static bool get isDarkMode => false;

  static Color get background =>
      isDarkMode ? ColorConstants.backgroundColorDark : ColorConstants.backgroundColorLight;

  static Color get primary => ColorConstants.primaryLight;

  static Color get text => ColorConstants.textLight;

  static Color get white => ColorConstants.white;

  static Color get black => ColorConstants.black;
}
