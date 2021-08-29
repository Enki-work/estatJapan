import 'package:dio/dio.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:flutter/material.dart';

import 'MenuDrawer.dart';

class ImmigrationStatisticsPage extends StatefulWidget {
  final String title;

  const ImmigrationStatisticsPage({Key? key, required this.title})
      : super(key: key);
  @override
  _ImmigrationStatisticsPageState createState() =>
      _ImmigrationStatisticsPageState();
}

class _ImmigrationStatisticsPageState extends State<ImmigrationStatisticsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text(widget.title),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: new MenuDrawer(), //抽屉
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('Business')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: (() {
        switch (_selectedIndex) {
          case 0:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: FutureBuilder(
                        future: _dio.get(
                            "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=7bed85b352e6c3d46ad6def4390196b23d86bcec&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0"),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                  ImmigrationStatisticsRoot.fromJson(
                                      response.data);
                              String a =
                                  rootModel.GET_STATS_DATA.RESULT.ERROR_MSG;
                              return Text(
                                '$a',
                              );
                            }
                          } else {
//请求未完成时弹出loading
                            return CircularProgressIndicator();
                          }
                        },
                      )),
                ],
              ),
            );
          case 1:
            return Center(child: Text("111"));
          case 2:
            return Center(child: Text("222"));
        }
      })(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
