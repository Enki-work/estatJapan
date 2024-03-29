import 'package:estatjapan/util/DioHolder.dart';
import 'package:state_notifier/state_notifier.dart';

import '../RouteModel.dart';
import '../jsonModel/ImmigrationStatisticsRoot.dart';
import '../state/AppConfigState.dart';
import '../state/RepositoryDataState.dart';

class APIRepositoryNotifier extends StateNotifier<RepositoryDataState>
    with LocatorMixin {
  APIRepositoryNotifier() : super(const RepositoryDataState());

  DioHolder get _dioHolder => read();
  AppConfigState get _appConfigState => read();

  String get _estatAppId => _appConfigState.estatAppId;

  set selectedIndex(int value) {
    state = state.copyWith(selectedIndex: value);
  }

  Future<void> getMenuData() async {
    if (_estatAppId.isEmpty) {
      return;
    }
    final res = await _dioHolder.getMenuData(_estatAppId);
    state = state.copyWith(immigrationStatisticsRoot: res);
  }

  Future<ImmigrationStatisticsRoot> getDataTable(RouteModel routeModel) async {
    final res = await _dioHolder.getDataTable(_estatAppId, routeModel);
    state = state.copyWith(dataTableData: res);
    return res;
  }

  Future<ImmigrationStatisticsRoot> getData(
      {required String selectedCat02,
      required String selectedCat03,
      String? selectedMonth}) async {
    final res = await _dioHolder.getData(_estatAppId,
        selectedMonth: selectedMonth,
        selectedCat02: selectedCat02,
        selectedCat03: selectedCat03);
    return res;
  }
}
