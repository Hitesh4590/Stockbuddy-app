import 'package:flutter/cupertino.dart';

import '../common/theme/image_constants.dart';
import '../common/widget/custom_popup_menu_entry.dart';

class OrdersScreenProvider extends ChangeNotifier {
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
}
