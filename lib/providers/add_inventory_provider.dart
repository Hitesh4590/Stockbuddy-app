import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockbuddy_flutter_app/local_packages/dropdown_textfield-master/lib/dropdown_textfield.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';

class AddInventoryProvider extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  String get selectedColor => _selectedColor;
  String _selectedColor = '';

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

  Future<Product?> getProductByTitle(String title) async {
    final querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .where('title', isEqualTo: title)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Product.fromFirestore(querySnapshot.docs.first.data());
    }
    return null;
  }

  Future<int> getTotalProducts() async {
    final querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .get();
    return querySnapshot.docs.length;
  }

  Future<bool> getProductDetailsBySku(int productId, String sku) async {
    final productRef = usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(productId.toString())
        .collection('ProductDetails')
        .doc(sku);
    final productSnapshot = await productRef.get();
    if (productSnapshot.exists) {
      return true;
    }
    return false;
  }

  Future<int> getTotalBatch(int productId, String sku) async {
    final querySnapshot = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(productId.toString())
        .collection('ProductDetails')
        .doc(sku)
        .collection('Batches')
        .get();
    return querySnapshot.docs.length;
  }

  Future<void> addBatch(int productId, String sku, ProductBatch batch) async {
    DocumentReference detailRef = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(productId.toString())
        .collection('ProductDetails')
        .doc(sku);
    await detailRef
        .collection('Batches')
        .doc(batch.batchId.toString())
        .set(batch.toMap());
    await detailRef.update({
      'in_stock': FieldValue.increment(batch.quantity),
    });
  }

  Future<void> addProductDetail(
      int productId, ProductDetail productDetail) async {
    DocumentReference detailRef = usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .doc(productId.toString())
        .collection('ProductDetails')
        .doc(productDetail.sku);
    await detailRef.set(productDetail.toMap());
    for (var batch in productDetail.batches) {
      DocumentReference batchRef =
          detailRef.collection('Batches').doc(batch.batchId.toString());
      await batchRef.set(batch.toMap());
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final DocumentReference productRef = usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Inventory')
          .doc(product.productId.toString());

      await productRef.set(product.toMap());
      for (var detail in product.productDetails) {
        DocumentReference detailRef =
            productRef.collection('ProductDetails').doc(detail.sku);
        await detailRef.set(detail.toMap());
        for (var batch in detail.batches) {
          final DocumentReference batchRef =
              detailRef.collection('Batches').doc(batch.batchId.toString());
          await batchRef.set(batch.toMap());
        }
      }

      print('Product added successfully!');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  List<DropDownValueModel> _dropDownList = [];

  List<DropDownValueModel> get dropDownList => _dropDownList;
  List<String> _color = [];

  List<String> get color => _color;
  List<String> sizes = [];
  Future<void> fetchAttribute() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('Attribute')
              .doc('size')
              .get();
      if (snapshot.exists) {
        final List<dynamic> sizesDynamic = snapshot.data()?['size'];
        sizes = sizesDynamic.cast<String>();
        _dropDownList = sizes
            .map((size) => DropDownValueModel(name: size, value: size))
            .toList();
      } else {
        print('Document size does not exist');
      }
      final DocumentSnapshot<Map<String, dynamic>> snapshot1 =
          await FirebaseFirestore.instance
              .collection('Attribute')
              .doc('color')
              .get();
      if (snapshot1.exists) {
        final List<dynamic> colorDynamic = snapshot1.data()?['color'];
        _color = colorDynamic.cast<String>();
      } else {
        print('Document size does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> changeLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }

  Color _pickColor = Colors.blue;
  Color get pickColor => _pickColor;
  Future<void> changeColor(Color color) async {
    _pickColor = color;
    notifyListeners();
  }

  Future<void> addColor() async {
    String color1 =
        pickColor.value.toRadixString(16).padLeft(8, '0').toUpperCase();
    if (!color.contains(color1)) {
      await FirebaseFirestore.instance
          .collection('Attribute')
          .doc('color')
          .update({
        'color': FieldValue.arrayUnion([color1])
      });
      await fetchAttribute();
    }
  }

  Future<void> addSize(String size) async {
    size = size.toUpperCase();
    if (!(sizes.contains(size))) {
      await FirebaseFirestore.instance
          .collection('Attribute')
          .doc('size')
          .update({
        'size': FieldValue.arrayUnion([size])
      });
      await fetchAttribute();
    }
  }
}
