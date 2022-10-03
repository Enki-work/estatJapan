import 'package:estatjapan/util/DioHolder.dart';
import 'package:state_notifier/state_notifier.dart';

import '../state/RootPageState.dart';

class RootPageNotifier extends StateNotifier<RootPageState> with LocatorMixin {
  RootPageNotifier() : super(const RootPageState());

  DioHolder get dioHolder => read();

  set selectedIndex(int value) {
    state = state.copyWith(selectedIndex: value);
  }

  Future<void> getMenuData(String estatAppId) async {
    final res = await dioHolder.getMenuData(estatAppId);
    state = state.copyWith(immigrationStatisticsRoot: res);
  }
}
