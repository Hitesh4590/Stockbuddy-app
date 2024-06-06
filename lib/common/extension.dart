import 'package:flutter/material.dart';
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

extension ExtWidgets on Widget {
  Widget lp(double space) => Padding(
        padding: EdgeInsets.only(left: space),
        child: this,
      );

  Widget rp(double space) => Padding(
        padding: EdgeInsets.only(right: space),
        child: this,
      );

  Widget tp(double space) => Padding(
        padding: EdgeInsets.only(top: space),
        child: this,
      );

  Widget bp(double space) => Padding(
        padding: EdgeInsets.only(bottom: space),
        child: this,
      );

  Widget hp(double width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: width),
        child: this,
      );

  Widget lrtbP(double left, double right, double top, double bottom) => Padding(
        padding:
            EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
        child: this,
      );

  Widget vp(double height) => Padding(
        padding: EdgeInsets.symmetric(vertical: height),
        child: this,
      );

  Widget hwp(double height, double width) => Padding(
        padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
        child: this,
      );

  Widget allp(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
}

class DateConsts {
  ///# dd/MM/yy
  static const String ddMMyy = 'dd/MM/yy';

  ///# dd/MM/yyyy
  static const String ddMMyyyy = 'dd/MM/yyyy';
  static const String ddMM = 'dd/MM';

  ///# MM/dd/yy
  static const String MMddyy = 'MM/dd/yy';

  ///# MM/dd/yyyy
  static const String MMddyyyy = 'MM/dd/yyyy';

  ///# EEEE, MMM dd, yyyy
  static const String EEEE_MMMdd_yyyy = 'EEEE, MMM dd, yyyy';

  static const String dd_MMMM_yyyy = 'dd MMMM, yyyy';

  ///# yyyy-MM-dd
  static const String serverDate = 'yyyy-MM-dd';

  ///# MMM dd,yyyy
  static const String mmmdd_YYYY = 'MMM dd,yyyy';
  static const String ddMMM = 'dd MMM';

  ///# yyyy-MM-dd HH:mm:ss
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';

  static const String hhmma = 'hh:mm a';

  static const String hhmma_MMddyyyy = 'hh:mm a, MM/dd/yyyy';
  static const String EEEEhmma = 'EEEE, h:mma';
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

extension GestureDetectorExtension on Widget {
  InkWell onTap(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: this,
    );
  }
}

extension Stringx on String {
  String? convertToAgo(
      {String inFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS", String text = ''}) {
    try {
      final DateTime input = DateFormat(inFormat).parse(this, true);
      final Duration diff = DateTime.now().difference(input);
      if (diff.inDays > 365) {
        return '${(diff.inDays / 365).floor()}y${diff.inDays == 1 ? '' : ''} $text';
      } else if (diff.inDays > 7) {
        return '${(diff.inDays / 7).floor()}w${diff.inDays == 1 ? '' : ''} $text';
      } else if (diff.inDays >= 1) {
        return '${diff.inDays}d${diff.inDays == 1 ? '' : ''} $text';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours}h${diff.inHours == 1 ? '' : ''} $text';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : ''} $text';
      } else if (diff.inSeconds >= 1) {
        return '${diff.inSeconds} sec${diff.inSeconds == 1 ? '' : ''} $text';
      } else {
        return 'just now';
      }
    } catch (e) {
      debugPrint('error while parsing $e');
      return null;
    }
  }
}

extension ServerFormattedDate on String {
  String getServerFormatDate() {
    final localDate = DateTime.parse(this).toLocal();
    final inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    final inputDate = inputFormat.parse(localDate.toString());
    final outputFormat = DateFormat('yyyy-MM-dd');
    final outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }
}

extension UserFormattedDate on String {
  String getUserFormatDate(
      {String format = 'yyyy-MM-dd HH:mm', String outFormat = 'dd/MM/yyyy'}) {
    final localDate = DateTime.parse(this).toLocal();

    /// inputFormat - format getting from api or other func.
    /// e.g If 2021-05-27 9:34:12.781341 then format should be yyyy-MM-dd HH:mm
    /// If 27/05/2021 9:34:12.781341 then format should be dd/MM/yyyy HH:mm
    final inputFormat = DateFormat(format);
    final inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    final outputFormat = DateFormat(outFormat);
    final outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }
}

extension DateTimeX on DateTime {
  String? formatDate({String outFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"}) {
    try {
      return DateFormat(outFormat).format(this);
    } catch (e) {
      return null;
    }
  }
}
