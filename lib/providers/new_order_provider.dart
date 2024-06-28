import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockbuddy_flutter_app/local_packages/dropdown_textfield-master/lib/dropdown_textfield.dart';
import '../model/product.dart';
import '../model/order.dart' as order;

class NewOrderProvider extends ChangeNotifier {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  List<DropDownValueModel> _skuDropDownList = [];

  List<DropDownValueModel> get skuDropDownList => _skuDropDownList;

  List<Product> _inventory = [];

  List<Product> get inventory => _inventory;

  List<ProductDetail> _allProductDetails = [];

  List<ProductDetail> get allProductDetails => _allProductDetails;

  Future<void> fetchInventory() async {
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
          if (productDetail.inStock > 0) {
            _allProductDetails.add(productDetail);
          }

          return productDetail;
        }).toList());

        productData['productDetails'] =
            productDetails.map((detail) => detail.toMap2()).toList();

        return Product.fromFirestore(productData);
      }).toList());

      _skuDropDownList = _allProductDetails
          .map((doc) => DropDownValueModel(name: doc.sku, value: doc.sku))
          .toList();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<ProductDetail> product = [];

  Future<void> getProductDetails(String sku) async {
    product = List.from(_allProductDetails.where((item) {
      return item.sku.toLowerCase().contains(sku.toLowerCase());
    }).toList());
    notifyListeners();
  }

  List<DropDownValueModel> allChannelDrop = [];

  Future<void> fetchAttributes() async {
    final DocumentReference channel = usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Channel')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final QuerySnapshot querySnapshot1 =
        await channel.collection('System_Channel').get();
    final QuerySnapshot querySnapshot2 =
        await channel.collection('User_Channel').get();
    final List<String> systemChannel =
        querySnapshot1.docs.map((doc) => doc['title'] as String).toList();
    final List<String> userChannel =
        querySnapshot2.docs.map((doc) => doc['title'] as String).toList();
    List<String> allChannel = systemChannel + userChannel;
    allChannelDrop = allChannel
        .map((title) => DropDownValueModel(name: title, value: title))
        .toList();

    notifyListeners();
  }

  List<order.OrderedProduct> _cart = [];

  List<order.OrderedProduct> get cart => _cart;

  Future<void> addToCart(order.OrderedProduct cartItem) async {
    _cart.add(cartItem);
    notifyListeners();
  }

  bool _discount = false;

  bool get discount => _discount;

  Future<void> toggleDiscount() async {
    _discount = !_discount;
    notifyListeners();
  }

  Future<int> getTotalOrder() async {
    final QuerySnapshot querySnapshot1 = await usersCollection
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Orders')
        .get();

    return querySnapshot1.docs.length;
  }

  Future<void> uploadOrder(order.Order newOrder) async {
    try {
      CollectionReference orders = usersCollection
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Orders');

      // Start a Firestore batch operation
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Add the new order to the Orders collection
      batch.set(orders.doc(newOrder.orderId.toString()), newOrder.toMap());

      // Collect update operations
      for (var orderedProduct in newOrder.orderedProducts) {
        // Query to find the relevant ProductDetail documents
        QuerySnapshot productDetailsSnapshot = await usersCollection
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('Inventory')
            .where('title', isEqualTo: orderedProduct.title)
            .get();

        // Process each ProductDetail
        for (var productDetailDoc in productDetailsSnapshot.docs) {
          DocumentReference productDetailRef = productDetailDoc.reference
              .collection('ProductDetails')
              .doc(orderedProduct.sku);

          // Fetch the ProductDetail document
          DocumentSnapshot productDetailSnapshot = await productDetailRef.get();
          Map<String, dynamic> productDetailData =
              productDetailSnapshot.data() as Map<String, dynamic>;

          // Update the in_stock value
          int newInStock =
              productDetailData['in_stock'] - orderedProduct.quantity;
          batch.update(productDetailRef, {'in_stock': newInStock});

          // Update each batch's available quantity
          for (var batchOrder in orderedProduct.batchOrders) {
            DocumentReference batchRef = productDetailRef
                .collection('Batches')
                .doc(batchOrder.batchId.toString());
            DocumentSnapshot batchSnapshot = await batchRef.get();
            Map<String, dynamic> batchData =
                batchSnapshot.data() as Map<String, dynamic>;

            // Decrease the available quantity
            int newAvailable = batchData['available'] - batchOrder.quantity;
            batch.update(batchRef, {'available': newAvailable});
          }
        }
      }

      // Commit the batch operation
      await batch.commit();

      print('uploaded successfully');
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
}
