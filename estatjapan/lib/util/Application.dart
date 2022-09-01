import 'package:estatjapan/model/state_notifier/AppConfigNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../model/pigeonModel/FlutterPurchaseModelApiHandler.dart';
import '../model/pigeonModel/PurchaseModelApi.dart';
import '../model/state/AppConfigState.dart';
import '../model/state/PurchaseModel.dart';
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
  PurchaseModel? _purchaseModel;

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
      setState(() {
        _purchaseModel = purchaseModel;
      });
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
    return MultiProvider(
      providers: [
        Provider<DioHolder>(create: (context) => widget.dioHolder),
        StateNotifierProvider<AppConfigNotifier, AppConfigState>(
          create: (_) => AppConfigNotifier(_purchaseModel),
        )
      ],
      // showCustomModalBottomSheetを使用するとステータスバーの文字色が白から戻らなくなる問題の回避策
      // see: https://github.com/jamesblasco/modal_bottom_sheet/issues/206#issuecomment-1062839762
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
        value: SystemUiOverlayStyle.dark,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
