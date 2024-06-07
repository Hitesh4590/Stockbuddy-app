import 'package:stockbuddy_flutter_app/common/i18n/i18n_engine.dart';
import 'package:stockbuddy_flutter_app/common/util/email_validator.dart';

class Validators {
  /// Check if first name is valid or not.
  bool isValidFirstName(String? input, {int maxLength = 20, RegExp? regExp}) {
    return ((regExp ?? RegExp('^[A-Za-z]+\$')).hasMatch(input ?? '') &&
        (input?.length ?? 0) <= maxLength);
  }

  /// Check if last name is valid or not
  bool isValidLastName(String? input, {int maxLength = 20, RegExp? regExp}) {
    return isValidFirstName(input, maxLength: maxLength, regExp: regExp);
  }

  /// Check if email is valid or not
  bool isValidEmail(String? input) {
    return EmailValidator.validate(input ?? '');
  }

  /// Check if password is valid or not
  bool isValidPassword(String? input, {RegExp? regExp, int maxLength = 24}) {
    return ((regExp ??
                RegExp(
                    '^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}\$'))
            .hasMatch(input ?? '') &&
        (input?.length ?? 0) <= maxLength);
  }

  bool isValidWebsite(String? input, {RegExp? regExp}) {
    final RegExp regex = RegExp(
      r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
      multiLine: false,
    );

    if (!regex.hasMatch(input ?? '')) {
      return false;
    }
    return true;
  }

  /// Check if confirm password matches main password
  bool isValidConfirmPassword(
      {required String? password, required String? confirmPassword}) {
    return password == confirmPassword;
  }

  bool isValidateMessage(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  bool isValidateFlag(bool? value) {
    if (value == null || value == false) {
      return false;
    }
    return true;
  }

  bool isValidateMobileNo(String? value) {
    if (value == null || value.length != 10) {
      return false;
    }
    return true;
  }

  /// Check if field is empty
  bool isValidateField(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }

  /// Common email validator function
  String? validateEmail(String? value) {
    if (!isValidateField(value)) {
      return 'enter_email'.i18n;
    } else if (!isValidEmail(value)) {
      return 'enter_valid_email'.i18n;
    } else {
      return null;
    }
  }

  /// Common phone number validator function
  String? validatePhoneNumber(String? value) {
    if (!isValidateField(value)) {
      return 'enter_phone_number'.i18n;
    } else if (!isValidateMobileNo(value)) {
      return 'error_mobile_digit_restriction'.i18n;
    } else {
      return null;
    }
  }

  /// Common email and phone number validator function
  String? validateEmailOrPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_email_or_phone_number'.i18n;
    }
    if (isValidEmail(value) || isValidateMobileNo(value)) {
      return null;
    } else {
      return 'invalid_email_or_phone_number'.i18n;
    }
  }
}
