import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockbuddy_flutter_app/model/product.dart';

class InventoryDetailsProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Future changePhoto(int index) async {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> edit(ProductDetail detail, ProductBatch batch, double sell,
      double buy, String supplier) async {
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
    DocumentReference batchDocRef = inventoryDocRef
        .collection('ProductDetails')
        .doc(detail.sku)
        .collection('Batches')
        .doc(batch.batchId.toString());

    // Get the batch document snapshot
    DocumentSnapshot batchDoc = await batchDocRef.get();

    if (batchDoc.exists) {
      batchDocRef.update(
          {'supplier_name': supplier, 'sell_price': sell, 'buy_price': buy});
    }
  }

  Future<String> delete(ProductDetail detail, ProductBatch batch) async {
    if (batch.quantity == batch.available) {
      try {
        // Retrieve the first matching inventory document reference
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
        DocumentReference inventoryDocRef =
            inventorySnapshot.docs.first.reference;

        // Get the batch document reference
        DocumentReference batchDocRef = inventoryDocRef
            .collection('ProductDetails')
            .doc(detail.sku)
            .collection('Batches')
            .doc(batch.batchId.toString());

        // Get the batch document snapshot
        DocumentSnapshot batchDoc = await batchDocRef.get();

        if (batchDoc.exists) {
          final int inStock = detail.inStock - batch.quantity;
          await inventoryDocRef
              .collection('ProductDetails')
              .doc(detail.sku)
              .update({'in_stock': inStock});
          // Delete the document
          await batchDocRef.delete();

          return 'can delete';
        } else {
          // Handle document not found
          return 'batch document not found';
        }
      } catch (e) {
        // Handle any errors that occur during the delete operation
        return 'Error: ${e.toString()}';
      }
    } else {
      return 'cannot delete';
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> changeLoading(bool value) async {
    _isLoading = value;
    notifyListeners();
  }
}
