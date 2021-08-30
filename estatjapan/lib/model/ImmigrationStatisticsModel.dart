import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ImmigrationStatisticsRoot.dart';

@JsonSerializable()
class ImmigrationStatisticsModel extends ChangeNotifier {
  int _selectedIndex = 0;
  ImmigrationStatisticsRoot? _rootModel = null;

  int get selectedIndex => this._selectedIndex;

  set selectedIndex(int value) {
    this._selectedIndex = value;
    notifyListeners();
  }

  ImmigrationStatisticsRoot? get model => this._rootModel;

  set rootModel(ImmigrationStatisticsRoot value) {
    this._rootModel = value;
    notifyListeners();
  }
}
