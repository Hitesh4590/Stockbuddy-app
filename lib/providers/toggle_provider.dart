import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  bool _rememberMe = false;
  bool _signinObscure = true;
  bool _signupPasswordObscure = true;
  bool _signupConfirmPasswordObscure = true;
  bool get rememberMe => _rememberMe;
  bool get signupPasswordObscure => _signupPasswordObscure;
  bool get signupConfirmPasswordObscure => _signupConfirmPasswordObscure;
  bool get signinObscure => _signinObscure;
  int _selectedScreen = 0;
  int get selectedScreen => _selectedScreen;

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void toggleSigninObscure() {
    _signinObscure = !_signinObscure;
    notifyListeners();
  }

  void toggleSignupPasswordObscure() {
    _signupPasswordObscure = !_signupPasswordObscure;
    notifyListeners();
  }

  void toggleSignupConfirmPasswordObscure() {
    _signupConfirmPasswordObscure = !_signupConfirmPasswordObscure;
    notifyListeners();
  }

  void changeScreen(int value) {
    _selectedScreen = value;
    notifyListeners();
  }
}
