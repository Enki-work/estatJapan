import 'package:estatjapan/Page/ImmigrationStatisticsPage.dart';
import 'package:flutter/material.dart';

import 'Page/DataTablePage.dart';
import 'Page/LicenseInfoPage.dart';
import 'Page/MonthSelectPage.dart';
import 'model/RouteModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const appId = '7bed85b352e6c3d46ad6def4390196b23d86bcec';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "MonthSelectPage": (context) => MonthSelectPage(
                routeModel:
                    ModalRoute.of(context)?.settings.arguments as RouteModel,
              ),
          "DataTablePage": (context) => DataTablePage(
                routeModel:
                    ModalRoute.of(context)?.settings.arguments as RouteModel,
              ),
          "LicenseInfoPage": (context) => LicenseInfoPage(),
          "/": (context) =>
              ImmigrationStatisticsPage(title: '在留資格の取得等の受理及び処理人員'),
        });
  }
}
