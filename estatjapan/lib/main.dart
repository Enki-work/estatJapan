import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Page/MenuDrawer.dart';
import 'model/ImmigrationStatisticsRoot.dart';

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
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: new MenuDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: _dio.get(
                      "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=7bed85b352e6c3d46ad6def4390196b23d86bcec&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      //请求完成
                      if (snapshot.hasError) {
                        //发生错误
                        return Text(snapshot.error.toString());
                      }
                      if (false) {
                        // Response response = snapshot.data;
                        // return ListView(
                        //     children: response.data.map<Widget>(
                        //         (e) => ListTile(title: Text(e["aa"]))));
                      } else {
                        Response response = snapshot.data;
                        ImmigrationStatisticsRoot rootModel =
                            ImmigrationStatisticsRoot.fromJson(response.data);
                        String a = rootModel.GET_STATS_DATA.RESULT.ERROR_MSG;
                        return Text(
                          '$a \n You have pushed the button this many times:',
                        );
                      }
                    } else {
                      //请求未完成时弹出loading
                      return CircularProgressIndicator();
                    }
                  },
                )),
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
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
