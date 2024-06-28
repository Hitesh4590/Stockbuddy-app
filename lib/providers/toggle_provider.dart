import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';

class ToggleProvider extends ChangeNotifier {
  bool _rememberMe = false;
  bool _signInObscure = true;
  bool _signupPasswordObscure = true;
  bool _signupConfirmPasswordObscure = true;
  bool get rememberMe => _rememberMe;
  bool get signupPasswordObscure => _signupPasswordObscure;
  bool get signupConfirmPasswordObscure => _signupConfirmPasswordObscure;
  bool get signInObscure => _signInObscure;
  int _selectedScreen = 0;
  int get selectedScreen => _selectedScreen;
  UserModel? user1;

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void toggleSignInObscure() {
    _signInObscure = !_signInObscure;
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

  Future<void> getUser(uid) async {
    try {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      final snapshot = await users.doc(uid).get();
      user1 = UserModel.fromDocument(snapshot);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  bool _isLoadingSignIn = false;
  bool get isLoadingSignIn => _isLoadingSignIn;
  Future<void> changeLoadingSignIn(bool value) async {
    _isLoadingSignIn = value;
    notifyListeners();
  }

  bool _isLoadingSignUp = false;
  bool get isLoadingSignUp => _isLoadingSignUp;
  Future<void> changeLoadingSignUp(bool value) async {
    _isLoadingSignUp = value;
    notifyListeners();
  }
}
