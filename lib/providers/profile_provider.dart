import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/company.dart';
import 'package:stockbuddy_flutter_app/model/user.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? userDetails;
  Company? companyDetails;
  Future<void> fetchDetails() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    userDetails = UserModel.fromDocument(snapshot);
    companyDetails = Company.fromDocument(snapshot);
    notifyListeners();
  }

  String downloadUrl = '';
  Future<String> uploadImages(image) async {
    final File file = File(image!.path);
    final String fileName =
        'images/${DateTime.now().millisecondsSinceEpoch.toString()}';
    try {
      // Upload to Firebase Storage
      final UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return downloadUrl;
  }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    await uploadImages(imageXFile);
  }

  Future<void> updateDetails(
      firstName, lastName, phone, Company companyUpdates) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(
            {'first_name': firstName, 'last_name': lastName, 'phone': phone});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(companyUpdates.toMap());
  }

  //change password screen
  //
  //
  bool _currentPassword = true;
  bool get currentPassword => _currentPassword;
  void toggleCurrentPassword() {
    _currentPassword = !_currentPassword;
    notifyListeners();
  }

  bool _password = true;
  bool get password => _password;
  bool _confirmPassword = true;
  bool get confirmPassword => _confirmPassword;
  void togglePassword() {
    _password = !_password;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    _confirmPassword = !_confirmPassword;
    notifyListeners();
  }

  Future<void> reAuthenticateUser(String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  Future<void> changePassword(BuildContext context, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .delete();
        user.delete();
      }
    } catch (e) {
      print(e);
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> changeLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;
  Future<void> changeLoadingDelete(bool value) async {
    _isLoadingDelete = value;
    notifyListeners();
  }
}
