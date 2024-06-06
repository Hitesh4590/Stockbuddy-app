import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stockbuddy_flutter_app/common/theme/image_constants.dart';
import '../common/widget/custom_popup_menu_entry.dart';
import '../model/inventory.dart';

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

  List<InventoryItem> _inventory = [];
  List<InventoryItem> get inventory => _inventory;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future fetchInventory() async {
    switch (selectedFilter) {
      case 'All':
        try {
          QuerySnapshot querySnapshot = await usersCollection
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Inventory')
              .get();
          _inventory = querySnapshot.docs
              .map((doc) => InventoryItem.fromDocument(doc))
              .toList();
          notifyListeners();
        } catch (e) {
          print(e);
        }
        break;
      case 'In-Stock':
        try {
          QuerySnapshot querySnapshot = await usersCollection
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Inventory')
              .where('quantity', isGreaterThan: 0)
              .get();
          _inventory = querySnapshot.docs
              .map((doc) => InventoryItem.fromDocument(doc))
              .toList();
          notifyListeners();
        } catch (e) {
          print(e);
        }
        break;
      case 'Out-of-Stock':
        try {
          QuerySnapshot querySnapshot = await usersCollection
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('Inventory')
              .where('quantity', isEqualTo: 0)
              .get();
          _inventory = querySnapshot.docs
              .map((doc) => InventoryItem.fromDocument(doc))
              .toList();
          notifyListeners();
        } catch (e) {
          print(e);
        }

        break;
    }
  }

  String _query = '';
  String get query => _query;
  Future<void> queryChanged(value) async {
    _query = value;

    notifyListeners();
    await searchResult();
  }

  Future<void> searchResult() async {
    await fetchInventory();
    _inventory = List.from(_inventory.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase());
    }).toList());
    notifyListeners();
  }
}
