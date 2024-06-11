import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/model/sku.dart';
import '../model/products.dart';

class AddInventoryProvider extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  int get selectedColor => _selectedColor;
  int _selectedColor = 0;

  List<XFile?> _images = List<XFile?>.filled(3, null);

  List<XFile?> get images => _images;

  Future toggleColor(value) async {
    _selectedColor = value;
    notifyListeners();
  }

  Future addImage(XFile image, int index) async {
    _images[index] = image;
    notifyListeners();
  }

  Future removeImage(int index) async {
    _images[index] = null;
    notifyListeners();
  }

  Future clearImageList() async {
    _images[0] = null;
    _images[1] = null;
    _images[2] = null;
    notifyListeners();
  }

  String _errorText = '';

  String get errorText => _errorText;

  void addImageError() {
    if (_images.every((element) => element == null)) {
      _errorText = 'Add at least one image';
    } else {
      _errorText = '';
    }
    notifyListeners();
  }

  Future<Product?> getProductByTitle(String title) async {
    final querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .where('title', isEqualTo: title)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Product.fromDocument(querySnapshot.docs.first);
    }
    return null;
  }

  Future<void> updateProduct(Product product) async {
    await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(product.id.toString())
        .update(product.toMap());
  }

  Future<void> addProduct(Product product) async {
    await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(product.id.toString())
        .set(product.toMap());
  }

  Future<void> addProductDetails(
      Product product, ProductDetails productDetails) async {
    final productRef = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(product.id.toString());
    await productRef.update({
      'inStock': product.inStock,
      'ProductDetails': FieldValue.arrayUnion([productDetails.toMap()]),
    });
  }

  Future<int> getTotalProducts() async {
    final querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> getTotalProductDetails(int productId) async {
    final productRef = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(productId.toString());
    final productSnapshot = await productRef.get();
    if (productSnapshot.exists) {
      final productData = productSnapshot.data();
      if (productData != null && productData.containsKey('ProductDetails')) {
        return (productData['ProductDetails'] as List<dynamic>).length;
      } else {
        return 0;
      }
    }
    return 0;
  }

  Future<void> addSku(Sku sku, int number) async {
    List<Sku> _skus = List<Sku>.filled(number, sku);
    for (int i = 0; i < number; i++) {
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Sku')
          .doc(DateTime.now().toIso8601String())
          .set(_skus[i].toMap());
    }
  }
}
