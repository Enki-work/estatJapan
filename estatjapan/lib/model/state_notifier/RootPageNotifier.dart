import 'package:state_notifier/state_notifier.dart';

import '../state/RootPageState.dart';

class RootPageNotifier extends StateNotifier<RootPageState> {
  RootPageNotifier() : super(const RootPageState());

  set selectedIndex(int value) {
    state = state.copyWith(selectedIndex: value);
  }
}
