import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import '../common/widget/custom_popup_menu_entry.dart';
import '../model/product.dart';

class InventoryListProvider extends ChangeNotifier {
  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  List<CustomPopupMenuEntry> filterPopupMenus({bool isSelected = false}) {
    return [
      CustomPopupMenuEntry(
        isSelected: (selectedFilter == 'All' ? true : isSelected),
        title: 'All',
        iconName: ImageConstants.filter,
      ),
      CustomPopupMenuEntry(
        isSelected: (selectedFilter == 'In-Stock' ? true : isSelected),
        title: 'In-Stock',
        iconName: ImageConstants.filter,
      ),
      CustomPopupMenuEntry(
        isSelected: (selectedFilter == 'Out-of-Stock' ? true : isSelected),
        title: 'Out-of-Stock',
        iconName: ImageConstants.filter,
      ),
    ];
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  List<Product> _inventory = [];

  List<Product> get inventory => _inventory;
  List<ProductDetail> _allProductDetails = [];

  List<ProductDetail> get productDetails => _allProductDetails;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future fetchInventory() async {
    try {
      _allProductDetails.clear();

      QuerySnapshot productSnapshot = await usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Inventory')
          .get();

      _inventory =
          await Future.wait(productSnapshot.docs.map((productDoc) async {
        Map<String, dynamic> productData =
            productDoc.data() as Map<String, dynamic>;

        QuerySnapshot detailsSnapshot =
            await productDoc.reference.collection('ProductDetails').get();

        List<ProductDetail> productDetails =
            await Future.wait(detailsSnapshot.docs.map((detailDoc) async {
          Map<String, dynamic> detailData =
              detailDoc.data() as Map<String, dynamic>;

          QuerySnapshot batchesSnapshot =
              await detailDoc.reference.collection('Batches').get();

          List<ProductBatch> batches = batchesSnapshot.docs.map((batchDoc) {
            Map<String, dynamic> batchData =
                batchDoc.data() as Map<String, dynamic>;
            return ProductBatch.fromFirestore(batchData);
          }).toList();

          detailData['batches'] =
              batches.map((batch) => batch.toMap()).toList();

          ProductDetail productDetail = ProductDetail.fromFirestore(detailData);

          switch (selectedFilter) {
            case 'All':
              _allProductDetails.add(productDetail);
              break;
            case 'In-Stock':
              if (productDetail.inStock > 0) {
                _allProductDetails.add(productDetail);
              }
              break;
            case 'Out-of-Stock':
              if (productDetail.inStock == 0) {
                _allProductDetails.add(productDetail);
              }
              break;
          }

          return productDetail;
        }).toList());

        productData['productDetails'] =
            productDetails.map((detail) => detail.toMap2()).toList();

        return Product.fromFirestore(productData);
      }).toList());

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Timer? _debounce;
  String _query = '';

  String get query => _query;

  Future<void> queryChanged(value) async {
    _query = value;

    notifyListeners();
    await searchResult();
  }

  Future<void> searchResult() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      await clearList();
      await fetchInventory();
      if (_query.isNotEmpty || _query != '') {
        _allProductDetails = List.from(_allProductDetails.where((item) {
          return item.sku.toLowerCase().contains(query.toLowerCase());
        }).toList());
      }
    });

    notifyListeners();
  }

  Future clearList() async {
    _allProductDetails.clear();
  }

  Future<void> edit(
    ProductDetail detail,
    String description,
    List<String> photos,
  ) async {
    QuerySnapshot inventorySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .where('title', isEqualTo: detail.title)
        .get();

    if (inventorySnapshot.docs.isEmpty) {
      // Handle no matching document found
      throw Exception('No matching inventory document found');
    }

    // Get the first matching document reference
    DocumentReference inventoryDocRef = inventorySnapshot.docs.first.reference;

    // Get the batch document reference
    DocumentReference ProductDocRef =
        inventoryDocRef.collection('ProductDetails').doc(detail.sku);
    DocumentSnapshot ProductDoc = await ProductDocRef.get();
    if (ProductDoc.exists) {
      ProductDocRef.update({'photos': photos, 'description': description});
    }
  }

  Future deleteProductDetail(ProductDetail detail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Inventory')
        .where('title', isEqualTo: detail.title)
        .get();
    DocumentReference productDoc = querySnapshot.docs.first.reference;
    DocumentReference detailDoc =
        productDoc.collection('ProductDetails').doc(detail.sku);
    await detailDoc.delete();
    await fetchInventory();
  }
}
