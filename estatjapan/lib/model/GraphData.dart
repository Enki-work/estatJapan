import 'package:estatjapan/Util/AppConfig.dart';
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

  bool isModelExist() {
    return (_selectedCat01Mode != null &&
        _selectedCat02Mode != null &&
        _selectedCat03Mode != null);
  }

  String get url {
    return 'http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?cdTab=160&appId=${AppConfig.shared.estatAppId}&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0&cdTime=${_selectedCat02Mode!.code}&cdCat01=${_selectedCat01Mode!.code}&cdCat03=${_selectedCat03Mode!.code}';
  }
}
