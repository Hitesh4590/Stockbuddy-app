import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AddInventoryProvider extends ChangeNotifier {
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
}
