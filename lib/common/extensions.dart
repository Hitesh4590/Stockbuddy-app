import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
//ignore_for_file: constant_identifier_names

extension Spacing on num {
  SizedBox get vs => SizedBox(
        height: toDouble(),
      );

  SizedBox get hs => SizedBox(
        width: toDouble(),
      );
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class DateConsts {
  ///# dd/MM/yy
  static const String ddMMyy = 'dd/MM/yy';
  ///# dd/MM/yyyy
  static const String ddMMyyyy = 'dd/MM/yyyy';
  ///# MM/dd/yy
  static const String MMddyy = 'MM/dd/yy';
  ///# MM/dd/yyyy
  static const String MMddyyyy = 'MM/dd/yyyy';
  ///# EEEE, MMM dd, yyyy
  static const String EEEE_MMMdd_yyyy = 'EEEE, MMM dd, yyyy';
  ///# yyyy-MM-dd
  static const String serverDate = 'yyyy-MM-dd';

  ///# MMM dd,yyyy
  static const String mmmdd_YYYY = 'MMM dd,yyyy';

  ///# yyyy-MM-dd HH:mm:ss
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
}

extension StringDateFormatExtension on DateTime {
  String getFormattedDate({String dateFormat = DateConsts.ddMMyyyy}) {
    return DateFormat(dateFormat).format(this);
  }

  bool isSameDayAs(DateTime date) {
    return (date.day == day) && (date.month == month) && (date.year == year);
  }
}

extension DateFormatExtension on String {
  String changeDateFormat(
      {String inputFormat = DateConsts.yyyyMMddHHmmss,
        required String outputFormat}) {
    if (isEmpty) {
      return '';
    }
    return DateFormat(inputFormat)
        .parse(this)
        .getFormattedDate(dateFormat: outputFormat);
  }

  DateTime getDateWithFormat({String inputFormat = DateConsts.yyyyMMddHHmmss}) {
    return DateFormat(inputFormat).parse(this);
  }
}
