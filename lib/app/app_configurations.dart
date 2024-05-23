import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/app/model/app_environment.dart';
import 'package:stockbuddy_flutter_app/common/consts/api_constants.dart';

class AppConfigurations {
  static late AppConfigurations _instance;

  AppConfigurations._internal(this._appEnvironment);

  late AppEnvironment _appEnvironment;

  AppEnvironment get appEnvironment => _appEnvironment;

  factory AppConfigurations({
    required AppEnvironment appEnvironment,
  }) {
    _instance = AppConfigurations._internal(appEnvironment);
    return _instance;
  }

  static AppConfigurations get instance {
    return _instance;
  }

  List<Locale>? _supportedLocales;

  List<Locale> get supportedLocales =>
      _supportedLocales ??
      <Locale>[
        const Locale('en'),
      ];

  String get apiBaseUrl => appEnvironment == AppEnvironment.dev
      ? ApiConstants.baseUrlDev
      : ApiConstants.baseUrlProd;
}
