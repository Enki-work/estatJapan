import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'DioHolder.dart';

class Application extends StatefulWidget {
  final bool isRestart;

  final DioHolder dioHolder;

  const Application({
    Key? key,
    this.isRestart = false,
    required this.dioHolder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _ApplicationState(
      isRestart: isRestart,
    );
  }
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  final bool isRestart;

  _ApplicationState({
    this.isRestart = false,
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    // Android Status Barを透過させるため
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [],
      // showCustomModalBottomSheetを使用するとステータスバーの文字色が白から戻らなくなる問題の回避策
      // see: https://github.com/jamesblasco/modal_bottom_sheet/issues/206#issuecomment-1062839762
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        child: Center(child: CircularProgressIndicator()),
        value: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
