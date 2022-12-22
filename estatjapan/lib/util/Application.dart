import 'package:estatjapan/model/state_notifier/AppConfigNotifier.dart';

import 'package:firebase_analytics/observer.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../model/GraphData.dart';
import '../model/RouteModel.dart';
import '../model/VisaInfoPageData.dart';
import '../model/jsonModel/ClassOBJ.dart';
import '../model/state/AppConfigState.dart';
import '../model/state/PurchaseState.dart';
import '../model/state/RepositoryDataState.dart';
import '../model/state_notifier/APIRepositoryNotifier.dart';
import '../model/state_notifier/PurchaseNotifier.dart';
import '../page/ContactMePage.dart';
import '../page/EStatInfoPage.dart';
import '../page/LicenseInfoPage.dart';
import '../page/MonthSelectPage.dart';
import '../page/PurchaseInfoPage.dart';
import '../page/RootPage.dart';
import '../page/SettingPage.dart';
import '../page/VisaInfoPage.dart';
import '../page/WebViewPage.dart';
import 'AppInitializer.dart';
import 'AppLifecycleReactor.dart';
import 'AppOpenAdManager.dart';
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
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _ApplicationState(
      isRestart: isRestart,
    );
  }
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  final bool isRestart;
  final appConfig = AppConfigNotifier();
  late AppLifecycleReactor _appLifecycleReactor;

  _ApplicationState({this.isRestart = false});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    // Android Status Barを透過させるため
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    Future(() async {
      await appConfig.forEnvironment();
      // FlutterPurchaseModelApi.setup(
      //     FlutterPurchaseModelApiHandler((purchaseModel) {
      //   appConfig.purchaseModel = purchaseModel;
      // }));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
          StateNotifierProvider<AppConfigNotifier, AppConfigState>.value(
            value: appConfig,
          ),
          StateNotifierProvider<APIRepositoryNotifier, RepositoryDataState>(
            create: (_) => APIRepositoryNotifier(),
          ),
          ChangeNotifierProvider(
            create: (_) => GraphData(),
          ),
          StateNotifierProvider<PurchaseNotifier, PurchaseState>(
            create: (_) => PurchaseNotifier()
              ..getIsAdDeletedDone()
              ..initStoreInfo()
              ..restorePurchases(),
          ),
        ],
        builder: (context, child) {
          return const MyHomePage();
        });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '在留資格統計',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
          scheme: context.watch<AppConfigState>().themeFlexScheme),
      darkTheme: FlexThemeData.dark(
          scheme: context.watch<AppConfigState>().themeFlexScheme),
      themeMode: context.watch<AppConfigState>().getThemeMode,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: AppInitializer.firebaseAnalytics)
      ],
      routes: {
        "MonthSelectPage": (context) {
          if (ModalRoute.of(context)?.settings.arguments is RouteModel) {
            return MonthSelectPage(
              routeModel:
                  ModalRoute.of(context)?.settings.arguments as RouteModel,
              pageType: MonthSelectPageType.old,
            );
          } else {
            return MonthSelectPage(
              monthClassObj:
                  ModalRoute.of(context)?.settings.arguments as ClassOBJ,
              pageType: MonthSelectPageType.graph,
            );
          }
        },
        "LicenseInfoPage": (context) => const LicenseInfoPage(),
        "eStaInfoPage": (context) => const EStaInfoPage(),
        "ContactMePage": (context) => const ContactMePage(),
        "WebViewPage": (context) {
          return WebViewPage(
              loadUrl: ModalRoute.of(context)?.settings.arguments as String?);
        },
        "VisaInfoPage": (context) {
          return VisaInfoPage(
            visaInfoPageData:
                ModalRoute.of(context)?.settings.arguments as VisaInfoPageData?,
          );
        },
        "SettingPage": (context) {
          return const SettingPage();
        },
        "PurchaseInfoPage": (context) {
          return const PurchaseInfoPage();
        },
        "/": (context) => const RootPage(title: '在留資格取得の受理・処理'),
      },
    );
  }
}

extension GetThemeMode on AppConfigState {
  ThemeMode get getThemeMode {
    if (isThemeFollowSystem) {
      return ThemeMode.system;
    } else if (isThemeDarkMode) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}
