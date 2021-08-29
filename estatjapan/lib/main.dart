import 'package:estatjapan/Page/ImmigrationStatisticsPage.dart';
import 'package:flutter/material.dart';

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
      home: ImmigrationStatisticsPage(title: 'Flutter Demo Home Page'),
    );
  }
}
