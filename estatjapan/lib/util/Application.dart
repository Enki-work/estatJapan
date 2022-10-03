import 'package:estatjapan/model/state_notifier/AppConfigNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../model/pigeonModel/FlutterPurchaseModelApiHandler.dart';
import '../model/pigeonModel/PurchaseModelApi.dart';
import '../model/state/AppConfigState.dart';
import '../page/RootPage.dart';
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

    FlutterPurchaseModelApi.setup(
        FlutterPurchaseModelApiHandler((purchaseModel) {
      context.read<AppConfigNotifier>().purchaseModel = purchaseModel;
    }));
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
    return MultiProvider(providers: [
      Provider<DioHolder>(create: (context) => widget.dioHolder),
      StateNotifierProvider<AppConfigNotifier, AppConfigState>(
        create: (_) => AppConfigNotifier()..forEnvironment(),
      )
    ], child: const MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '在留資格統計',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.orange,
          iconTheme: const IconThemeData(color: Colors.orangeAccent)),
      darkTheme: ThemeData(
          primarySwatch: Colors.deepOrange,
          iconTheme: const IconThemeData(color: Colors.deepOrangeAccent)),
      themeMode: context.watch<AppConfigNotifier>().getThemeMode(),
      home: const RootPage(title: '在留資格取得の受理・処理'),
    );
  }
}
