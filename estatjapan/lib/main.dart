import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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

const bool isRelease =
    bool.fromEnvironment('dart.vm.product', defaultValue: false);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
  Future<_MyAppStateData> _getMyAppStateData() async {
    return _MyAppStateData(
        await Firebase.initializeApp(), await AppConfig.forEnvironment());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getMyAppStateData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: Colors.orange,
                    iconTheme: const IconThemeData(color: Colors.orangeAccent)),
                darkTheme: ThemeData(
                    primarySwatch: Colors.deepOrange,
                    iconTheme:
                        const IconThemeData(color: Colors.deepOrangeAccent)),
                navigatorObservers: <NavigatorObserver>[
                    MyApp.observer
                  ],
                routes: {
                    "MonthSelectPage": (context) {
                      if (ModalRoute.of(context)?.settings.arguments
                          is RouteModel) {
                        return MonthSelectPage(
                          routeModel: ModalRoute.of(context)?.settings.arguments
                              as RouteModel,
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
                          routeModel: ModalRoute.of(context)?.settings.arguments
                              as RouteModel,
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
                    "/": (context) => const RootPage(title: '在留資格取得の受理・処理'),
                  })
            : const Center(child: CircularProgressIndicator()));
  }
}

class _MyAppStateData {
  final FirebaseApp firebaseApp;
  final AppConfig appConfig;

  _MyAppStateData(this.firebaseApp, this.appConfig);
}
