import 'package:dio/dio.dart';
import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/ImmigrationStatisticsModel.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  ImmigrationStatisticsModel model = ImmigrationStatisticsModel();

  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return FutureBuilder(
        future: _dio.get(
            "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?cdTab=160&appId=7bed85b352e6c3d46ad6def4390196b23d86bcec&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            Response response = snapshot.data;
            ImmigrationStatisticsRoot rootModel =
                ImmigrationStatisticsRoot.fromJson(response.data);
            model.rootModel = rootModel;
            return ChangeNotifierProvider<ImmigrationStatisticsModel>(
                create: (_) => model,
                child: Scaffold(
                    appBar: AppBar(
                      //导航栏
                      title: Text(widget.title),
                      actions: <Widget>[
                        //导航栏右侧菜单
                        // IconButton(icon: Icon(Icons.share), onPressed: () {}),
                      ],
                    ),
                    drawer: new MenuDrawer(), //抽屉
                    bottomNavigationBar: Builder(builder: (context) {
                      return BottomNavigationBar(
                        // 底部导航
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon: Icon(Icons.add_chart_rounded),
                              title: Text('在留資格審査')),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.align_horizontal_left_rounded),
                              title: Text('審査受理・処理')),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.all_inbox_rounded),
                              title: Text('在留管理局・支局')),
                        ],
                        currentIndex:
                            Provider.of<ImmigrationStatisticsModel>(context)
                                .selectedIndex,
                        fixedColor: Colors.blue,
                        onTap: (index) => model.selectedIndex = index,
                      );
                    }),
                    body: Builder(builder: (context) {
                      switch (Provider.of<ImmigrationStatisticsModel>(context)
                          .selectedIndex) {
                        case 0:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Consumer<ImmigrationStatisticsModel>(
                                builder: (context, value, _) {
                                  if (value.model == null)
                                    return Center(child: Text("予想外エラー"));
                                  return _cat01ListView(value.model!);
                                },
                              )
                            ],
                          );
                        case 1:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Consumer<ImmigrationStatisticsModel>(
                                builder: (context, value, _) {
                                  if (value.model == null)
                                    return Center(child: Text("予想外エラー"));
                                  return _cat02ListView(value.model!);
                                },
                              )
                            ],
                          );
                        case 2:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Consumer<ImmigrationStatisticsModel>(
                                builder: (context, value, _) {
                                  if (value.model == null)
                                    return Center(child: Text("予想外エラー"));
                                  return _cat03ListView(value.model!);
                                },
                              )
                            ],
                          );
                        default:
                          return Center(child: Text("予想外エラー"));
                      }
                    })));
          } else {
//请求未完成时弹出loading
            return Scaffold(
                appBar: AppBar(
                  //导航栏
                  title: Text(widget.title),
                ),
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _cat01ListView(ImmigrationStatisticsRoot rootModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat01");
    return Expanded(
        child: ListView.separated(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount: obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Class CLASS = obj.CLASS[index];
        return ListTile(
          title: Text(CLASS.name),
          minVerticalPadding: 25,
          onTap: () {
            CLASS.parentID = obj.id;
            Navigator.of(context).pushNamed("MonthSelectPage",
                arguments:
                    RouteModel(rootModel: rootModel, selectedCLASS: CLASS));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        indent: 20,
        color: Colors.grey[120],
      ),
    ));
  }

  Widget _cat02ListView(ImmigrationStatisticsRoot rootModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat02");
    return Expanded(
        child: ListView.separated(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount: obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Class CLASS = obj.CLASS[index];
        return ListTile(
          title: Text(CLASS.name),
          minVerticalPadding: 25,
          onTap: () {
            CLASS.parentID = obj.id;
            Navigator.of(context).pushNamed("MonthSelectPage",
                arguments:
                    RouteModel(rootModel: rootModel, selectedCLASS: CLASS));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        indent: 20,
        color: Colors.grey[120],
      ),
    ));
  }

  Widget _cat03ListView(ImmigrationStatisticsRoot rootModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat03");
    return Expanded(
        child: ListView.separated(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount: obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Class CLASS = obj.CLASS[index];
        return ListTile(
          title: Text(CLASS.name),
          minVerticalPadding: 25,
          onTap: () {
            CLASS.parentID = obj.id;
            Navigator.of(context).pushNamed("MonthSelectPage",
                arguments:
                    RouteModel(rootModel: rootModel, selectedCLASS: CLASS));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        indent: 20,
        color: Colors.grey[120],
      ),
    ));
  }
}
