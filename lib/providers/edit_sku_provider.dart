import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';

class EditSkuProvider extends ChangeNotifier {
  List<String> _imageUrls = ['', '', '']; // Initialize with 3 empty strings

  List<String> get imageUrls => _imageUrls;

  Future<void> clearImages() async {
    _imageUrls = ['', '', ''];
    notifyListeners();
  }

  Future<void> fetchImages(ProductDetail detail) async {
    try {
      QuerySnapshot inventorySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Inventory')
          .where('title', isEqualTo: detail.title)
          .get();

      if (inventorySnapshot.docs.isNotEmpty) {
        DocumentReference inventoryDocRef =
            inventorySnapshot.docs.first.reference;
        DocumentReference doc1 =
            inventoryDocRef.collection('ProductDetails').doc(detail.sku);
        DocumentSnapshot doc = await doc1.get();

        if (doc.exists && doc.data() != null) {
          List<String>? photos = List<String>.from(doc['photos'] ?? []);

          if (photos.length >= 3) {
            _imageUrls = photos;
          } else {
            for (int i = 0; i < photos.length; i++) {
              _imageUrls[i] = photos[i];
            }
          }
        } else {
          _imageUrls = ['', '', ''];
        }
      } else {
        _imageUrls = ['', '', ''];
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching images: $e');
      _imageUrls = ['', '', ''];
      notifyListeners();
    }
  }

  Future<void> pickImage(int index) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(File(pickedFile.path));
        String downloadUrl = await ref.getDownloadURL();

        _imageUrls[index] = downloadUrl;
        notifyListeners();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> save(ProductDetail detail, String description) async {
    QuerySnapshot inventorySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .where('title', isEqualTo: detail.title)
        .get();

    if (inventorySnapshot.docs.isNotEmpty) {
      DocumentReference inventoryDocRef =
          inventorySnapshot.docs.first.reference;
      DocumentReference doc1 =
          inventoryDocRef.collection('ProductDetails').doc(detail.sku);
      DocumentSnapshot doc = await doc1.get();

      if (doc.exists && doc.data() != null) {
        await doc1.update({'photos': _imageUrls, 'description': description});
      }
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> changeLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }
}
