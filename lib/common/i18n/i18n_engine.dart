import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:stockbuddy_flutter_app/common/i18n/i18n_utils.dart';

class I18nEngine {
  Future<void> init(List<Locale> supportedLocales) async {
    final asset = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> json = jsonDecode(asset);

    final supportedLanguageCodes = supportedLocales.map((e) => e.languageCode).toList();

    final List jsonFiles = json.keys
        .where((element) {
          return element.contains('i18n/') && element.endsWith('.json');
        })
        .toList()
        .where((element) {
          final languageCode = (element.split('i18n/')[1]).split('.json')[0];
          return supportedLanguageCodes.contains(languageCode);
        })
        .toList();

    debugPrint('//// JSON Files: $jsonFiles');
    final Map<String, Map<String, String>> languagesMatrix = {};

    for (final String file in jsonFiles) {
      final languageCode = (file.split('i18n/')[1]).split('.json')[0];

      final translations = await I18nUtils.getMatrix(file);
      final existingTranslations = languagesMatrix[languageCode] ?? <String, String>{};

      translations.forEach((key, value) {
        if (existingTranslations.containsKey(key)) {
          throw Exception('Duplicate Key($key) found in $file');
        }
      });

      existingTranslations.addAll(translations);
      languagesMatrix[languageCode] = existingTranslations;
    }

    I18nExtended.init(supportedLocales[0].languageCode, languagesMatrix);
  }
}

extension I18nExtended on String {
  static late Translations _t;

  static void init(String languageCode, Map<String, Map<String, String>> translations) {
    _t = Translations.byLocale(languageCode) + translations;
  }

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(i18n, params);

  String plural(int value) => localizePlural(value, this, _t);
}
