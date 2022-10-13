import 'package:flutter/cupertino.dart';

import 'jsonModel/Class.dart';

class GraphData extends ChangeNotifier {
  Class? _selectedCat02Mode;
  Class? _selectedMonth;
  Class? _selectedCat03Mode;

  Class? get selectedCat02Mode => _selectedCat02Mode;
  set selectedCat02Mode(Class? selectedCat01Mode) {
    _selectedCat02Mode = selectedCat01Mode;
    notifyListeners();
  }

  Class? get selectedMonth => _selectedMonth;
  set selectedMonth(Class? selectedMonth) {
    _selectedMonth = selectedMonth;
    notifyListeners();
  }

  Class? get selectedCat03Mode => _selectedCat03Mode;
  set selectedCat03Mode(Class? selectedCat03Mode) {
    _selectedCat03Mode = selectedCat03Mode;
    notifyListeners();
  }

  bool isModelExist() {
    return (_selectedCat02Mode != null &&
        _selectedMonth != null &&
        _selectedCat03Mode != null);
  }
}
