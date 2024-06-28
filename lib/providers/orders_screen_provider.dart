import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../common/theme/image_constants.dart';
import '../common/widget/custom_popup_menu_entry.dart';
import '../model/order.dart' as order;

class OrdersScreenProvider extends ChangeNotifier {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  List<order.Order> _allOrders = [];
  List<order.Order> get allOrders => _allOrders;
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Orders')
          .get();

      List<order.Order> fetchedOrders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return order.Order.fromFirestore(data);
      }).toList();

      _allOrders = fetchedOrders;
      notifyListeners();
    } catch (e) {
      print('Error fetching orders: $e');
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
      await fetchOrders();
      if (_query.isNotEmpty || _query != '') {
        _allOrders = List.from(_allOrders.where((item) {
          return item.customerName.toLowerCase().contains(query.toLowerCase());
        }).toList());
      }
    });

    notifyListeners();
  }

  Future clearList() async {
    _allOrders.clear();
  }
}
