import 'package:flutter/cupertino.dart';

class InventoryDetailsProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Future changePhoto(int index) async {
    _selectedIndex = index;
    notifyListeners();
  }
}
