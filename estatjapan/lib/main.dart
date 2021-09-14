import 'package:flutter/material.dart';

import 'Page/ContactMePage.dart';
import 'Page/DataTablePage.dart';
import 'Page/EStatInfoPage.dart';
import 'Page/LicenseInfoPage.dart';
import 'Page/MonthSelectPage.dart';
import 'Page/RootPage.dart';
import 'Page/VisaTypeSelectPage.dart';
import 'Page/WebViewPage.dart';
import 'Util/AppConfig.dart';
import 'model/ClassOBJ.dart';
import 'model/RouteModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
                    iconTheme: const IconThemeData(color: Colors.orangeAccent)),
                darkTheme: ThemeData(
                    primarySwatch: Colors.deepOrange,
                    iconTheme:
                        const IconThemeData(color: Colors.deepOrangeAccent)),
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
