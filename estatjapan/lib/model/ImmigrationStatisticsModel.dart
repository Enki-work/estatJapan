import 'package:flutter/cupertino.dart';

import 'ImmigrationStatisticsRoot.dart';

class ImmigrationStatisticsModel extends ChangeNotifier {
  int _selectedIndex = 0;
  ImmigrationStatisticsRoot? _rootModel;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  ImmigrationStatisticsRoot? get model => _rootModel;

  set rootModel(ImmigrationStatisticsRoot value) {
    _rootModel = value;
    notifyListeners();
  }
}
