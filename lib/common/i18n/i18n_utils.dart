import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:i18n_extension/i18n_extension.dart';

class I18nUtils {
  static Future<Map<String, String>> getMatrix(String path) async {
    try {
      final String jsonLocale = await rootBundle.loadString(path, cache: false);

      final jsonAsMap = json.decode(jsonLocale).cast<String, String>();
      final convertedMap = <String, String>{};
      final tmpPluralMap = <String, String>{};
      jsonAsMap.forEach((key, value) {
        // * All plural modifiers should start with square brackets and related number or 'M' (for multi) within them
        if (!key.startsWith('[')) {
          if (tmpPluralMap.isNotEmpty) {
            convertedMap[tmpPluralMap.keys.first] = _getConvertedPlural(tmpPluralMap);
            tmpPluralMap.clear();
          }
          convertedMap[key] = value;
        } else {
          // * If two different keys that need to be pluralized occur one after another the first one must be handled before the second one can be recorded
          if (tmpPluralMap.isNotEmpty &&
              key.substring(key.indexOf(']') + 1) != tmpPluralMap.keys.first) {
            convertedMap[tmpPluralMap.keys.first] = _getConvertedPlural(tmpPluralMap);
            tmpPluralMap.clear();
          }
          final String pluralValue = key.substring(key.indexOf(']') + 1);
          tmpPluralMap.putIfAbsent(pluralValue, () => pluralValue);
          tmpPluralMap[key.substring(0, key.indexOf(']') + 1)] = value;
        }
      });
      // * If the translation matrix contains plural row as the last row, then we need to review this map once again
      if (tmpPluralMap.isNotEmpty) {
        convertedMap[tmpPluralMap.keys.first] = _getConvertedPlural(tmpPluralMap);
        tmpPluralMap.clear();
      }
      return convertedMap;
    } catch (error, stack) {
      log(error.toString(), stackTrace: stack);
      rethrow;
    }
  }

  static String _getConvertedPlural(Map<String, String> tmpMap) {
    var pluralString = tmpMap[tmpMap.keys.first];
    tmpMap.remove(tmpMap.keys.first);
    tmpMap.forEach((key, value) {
      pluralString = pluralString!.modifier(key.substring(1, key.length - 1),
          RegExp(r'\[([0-9]+|M)\]').hasMatch(key) ? value : tmpMap.values.first);
    });
    return pluralString!;
  }
}
