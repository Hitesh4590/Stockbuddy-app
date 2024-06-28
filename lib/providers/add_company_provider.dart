import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/company.dart';
import 'package:stockbuddy_flutter_app/providers/toggle_provider.dart';

class AddCompanyProvider extends ChangeNotifier {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
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

    return downloadUrl;
  }

  Future<void> uploadCompanyDetails(Company newCompany) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(newCompany.toMap());
    await users
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'isCompany': true});
    await ToggleProvider().getUser(FirebaseAuth.instance.currentUser?.uid);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> changeLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }
}
