import 'dart:async';

import 'package:estatjapan/model/pigeonModel/FlutterPurchaseModelApiHandler.dart';
import 'package:estatjapan/page/PurchaseInfoPage.dart';
import 'package:estatjapan/page/SettingPage.dart';
import 'package:estatjapan/page/VisaInfoPage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Page/BureauSelectPage.dart';
import 'Page/ContactMePage.dart';
import 'Page/DataTablePage.dart';
import 'Page/EStatInfoPage.dart';
import 'Page/GraphDataPage.dart';
import 'Page/LicenseInfoPage.dart';
import 'Page/LineGraphDataPage.dart';
import 'Page/MonthSelectPage.dart';
import 'Page/RootPage.dart';
import 'Page/VisaTypeSelectPage.dart';
import 'Page/WebViewPage.dart';
import 'Util/AppConfig.dart';
import 'model/ClassOBJ.dart';
import 'model/GraphData.dart';
import 'model/RouteModel.dart';
import 'model/VisaInfoPageData.dart';
import 'model/pigeonModel/PurchaseModelApi.dart';

const bool isRelease =
    bool.fromEnvironment('dart.vm.product', defaultValue: false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isinitialized = false;

  @override
  void initState() {
    super.initState();
    FlutterPurchaseModelApi.setup(
        FlutterPurchaseModelApiHandler((purchaseModel) {
      setState(() {
        AppConfig.shared.purchaseModel = purchaseModel;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isinitialized
            ? Future<AppConfig>.value(AppConfig.shared)
            : AppConfig.forEnvironment(),
        builder: (context, snapshot) {
          // ChangeNotifierProvider
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            isinitialized = true;
            final config = snapshot.data as AppConfig;
            return ChangeNotifierProvider.value(
              value: config,
              child: Consumer(builder: (context, AppConfig appConfig, child) {
                return MaterialApp(
                    title: '??????????????????',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                        primarySwatch: Colors.orange,
                        iconTheme:
                            const IconThemeData(color: Colors.orangeAccent)),
                    darkTheme: ThemeData(
                        primarySwatch: Colors.deepOrange,
                        iconTheme: const IconThemeData(
                            color: Colors.deepOrangeAccent)),
                    themeMode: appConfig.getThemeMode(),
                    navigatorObservers: <NavigatorObserver>[
                      MyApp.observer
                    ],
                    routes: {
                      "MonthSelectPage": (context) {
                        if (ModalRoute.of(context)?.settings.arguments
                            is RouteModel) {
                          return MonthSelectPage(
                            routeModel: ModalRoute.of(context)
                                ?.settings
                                .arguments as RouteModel,
                            pageType: MonthSelectPageType.old,
                          );
                        } else {
                          return MonthSelectPage(
                            monthClassObj: ModalRoute.of(context)
                                ?.settings
                                .arguments as ClassOBJ,
                            pageType: MonthSelectPageType.graph,
                          );
                        }
                      },
                      "DataTablePage": (context) => DataTablePage(
                            routeModel: ModalRoute.of(context)
                                ?.settings
                                .arguments as RouteModel,
                          ),
                      "LicenseInfoPage": (context) => const LicenseInfoPage(),
                      "eStaInfoPage": (context) => const EStaInfoPage(),
                      "ContactMePage": (context) => const ContactMePage(),
                      "VisaTypeSelectPage": (context) {
                        return VisaTypeSelectPage(
                          obj: ModalRoute.of(context)?.settings.arguments
                              as ClassOBJ,
                        );
                      },
                      "BureauSelectPage": (context) {
                        return BureauSelectPage(
                          obj: ModalRoute.of(context)?.settings.arguments
                              as ClassOBJ,
                        );
                      },
                      "GraphDataPage": (context) {
                        return GraphDataPage(
                          graphData: ModalRoute.of(context)?.settings.arguments
                              as GraphData,
                        );
                      },
                      "LineGraphDataPage": (context) {
                        return LineGraphDataPage(
                          graphData: ModalRoute.of(context)?.settings.arguments
                              as GraphData,
                        );
                      },
                      "WebViewPage": (context) {
                        return WebViewPage(
                            loadUrl: ModalRoute.of(context)?.settings.arguments
                                as String?);
                      },
                      "VisaInfoPage": (context) {
                        return VisaInfoPage(
                          visaInfoPageData: ModalRoute.of(context)
                              ?.settings
                              .arguments as VisaInfoPageData?,
                        );
                      },
                      "SettingPage": (context) {
                        return const SettingPage();
                      },
                      "PurchaseInfoPage": (context) {
                        return const PurchaseInfoPage();
                      },
                      "/": (context) => const RootPage(title: '????????????????????????????????????'),
                    });
              }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
