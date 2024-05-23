import 'package:flutter/material.dart';
import 'package:stockbuddy_flutter_app/app/app_configurations.dart';
import 'package:stockbuddy_flutter_app/app/model/app_environment.dart';
import 'package:stockbuddy_flutter_app/common/i18n/i18n_engine.dart';
import 'package:stockbuddy_flutter_app/common/util/preference_manager.dart';

import 'app/my_app.dart';

Future<void> start(AppEnvironment appEnvironment) async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfigurations(appEnvironment: appEnvironment);

  /// Initialise preference manager!
  await PreferenceManager().init();

  /// Initialise localization!
  await I18nEngine().init(AppConfigurations.instance.supportedLocales);

  /// Run the main app
  runApp(const MyApp());
}
