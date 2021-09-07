import 'package:estatjapan/Page/ImmigrationStatisticsPage.dart';
import 'package:flutter/material.dart';

import 'Page/ContactMePage.dart';
import 'Page/DataTablePage.dart';
import 'Page/LicenseInfoPage.dart';
import 'Page/MonthSelectPage.dart';
import 'Page/eStatInfoPage.dart';
import 'Util/AppConfig.dart';
import 'model/RouteModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AppConfig.forEnvironment(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                    primarySwatch: Colors.orange,
                    iconTheme: IconThemeData(color: Colors.orangeAccent)),
                darkTheme: ThemeData(
                    primarySwatch: Colors.deepOrange,
                    iconTheme: IconThemeData(color: Colors.deepOrangeAccent)),
                routes: {
                    "MonthSelectPage": (context) => MonthSelectPage(
                          routeModel: ModalRoute.of(context)?.settings.arguments
                              as RouteModel,
                        ),
                    "DataTablePage": (context) => DataTablePage(
                          routeModel: ModalRoute.of(context)?.settings.arguments
                              as RouteModel,
                        ),
                    "LicenseInfoPage": (context) => LicenseInfoPage(),
                    "eStaInfoPage": (context) => eStaInfoPage(),
                    "ContactMePage": (context) => ContactMePage(),
                    "/": (context) =>
                        ImmigrationStatisticsPage(title: '在留資格取得の受理・処理'),
                  })
            : Center(child: CircularProgressIndicator()));
  }
}
