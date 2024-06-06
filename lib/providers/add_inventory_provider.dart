import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AddInventoryProvider extends ChangeNotifier {
  int get selectedColor => _selectedColor;
  int _selectedColor = 0;
  XFile? _image1;

  XFile? get image1 => _image1;
  XFile? _image2;

  XFile? get image2 => _image2;
  XFile? _image3;

  XFile? get image3 => _image3;
  List<XFile> _images = [];
  List<XFile> get image => _images;

  Future toggleColor(value) async {
    _selectedColor = value;
    notifyListeners();
  }

  Future addImage(XFile image, int value) async {
    switch (value) {
      case 0:
        _image1 = image;
        notifyListeners();
        break;
      case 1:
        _image2 = image;
        notifyListeners();
        break;
      case 2:
        _image3 = image;
        notifyListeners();
        break;
    }
  }

  Future removeImage(int value) async {
    switch (value) {
      case 0:
        _image1 = null;
        notifyListeners();
        break;
      case 1:
        _image2 = null;
        notifyListeners();
        break;
      case 2:
        _image3 = null;
        notifyListeners();
    }
  }

  String _errorText = '';
  String get errorText => _errorText;

  void addImageError() {
    if (image1 == null && image2 == null && image3 == null) {
      _errorText = 'Add atleast one image';
    } else {
      _errorText = '';
    }
    notifyListeners();
  }
}
