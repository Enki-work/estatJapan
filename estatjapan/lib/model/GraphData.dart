import 'package:flutter/cupertino.dart';

import 'Class.dart';

class GraphData extends ChangeNotifier {
  Class? _selectedCat01Mode;
  Class? _selectedCat02Mode;
  Class? _selectedCat03Mode;

  Class? get selectedCat01Mode => _selectedCat01Mode;
  set selectedCat01Mode(Class? selectedCat01Mode) {
    _selectedCat01Mode = selectedCat01Mode;
    notifyListeners();
  }

  Class? get selectedCat02Mode => _selectedCat02Mode;
  set selectedCat02Mode(Class? selectedCat02Mode) {
    _selectedCat02Mode = selectedCat02Mode;
    notifyListeners();
  }

  Class? get selectedCat03Mode => _selectedCat03Mode;
  set selectedCat03Mode(Class? selectedCat03Mode) {
    _selectedCat03Mode = selectedCat03Mode;
    notifyListeners();
  }

  bool isModelNull() {
    return (_selectedCat01Mode != null &&
        _selectedCat02Mode != null &&
        _selectedCat03Mode != null);
  }
}
