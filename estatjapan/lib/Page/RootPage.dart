// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:estatjapan/Util/AppConfig.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/ImmigrationStatisticsModel.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'GraphDataSelectPage.dart';
import 'MenuDrawer.dart';
import 'VisaInfoPage.dart';

class RootPage extends StatelessWidget {
  final String title;
  const RootPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return FutureBuilder(
        future: _dio.get(
            "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?cdTab=160&appId=${AppConfig.shared.estatAppId}&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            Response response = snapshot.data;
            ImmigrationStatisticsRoot rootModel =
                ImmigrationStatisticsRoot.fromJson(response.data);
            ImmigrationStatisticsModel model = ImmigrationStatisticsModel();
            model.rootModel = rootModel;
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider<ImmigrationStatisticsModel>.value(
                      value: model),
                  ChangeNotifierProvider<BannerAdModel>(
                      create: (_) => BannerAdModel()..loadBannerAd()),
                ],
                child: FutureBuilder<InitializationStatus>(
                    future: _initGoogleMobileAds(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.done
                            ? getPageWidget()
                            : Scaffold(
                                appBar: AppBar(
                                  //导航栏
                                  title: Text(title),
                                ),
                                body: const Center(
                                    child: CircularProgressIndicator()))));
          } else {
//请求未完成时弹出loading
            return Scaffold(
                appBar: AppBar(
                  //导航栏
                  title: Text(title),
                ),
                body: const Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget _cat01ListView(
      ImmigrationStatisticsRoot rootModel, BannerAdModel bAdModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat01");
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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

  // Widget _cat02ListView(
  //     ImmigrationStatisticsRoot rootModel, BannerAdModel bAdModel) {
  //   ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
  //       .firstWhere((e) => e.id == "cat02");
  //   return Expanded(
  //       child: ListView.separated(
  //     padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //     itemCount: obj.CLASS.length,
  //     shrinkWrap: true,
  //     itemBuilder: (BuildContext context, int index) {
  //       Class CLASS = obj.CLASS[index];
  //       return ListTile(
  //         title: Text(CLASS.name),
  //         minVerticalPadding: 25,
  //         onTap: () {
  //           CLASS.parentID = obj.id;
  //           Navigator.of(context).pushNamed("MonthSelectPage",
  //               arguments:
  //                   RouteModel(rootModel: rootModel, selectedCLASS: CLASS));
  //         },
  //       );
  //     },
  //     separatorBuilder: (BuildContext context, int index) => Divider(
  //       height: 0.5,
  //       indent: 20,
  //       color: Colors.grey[120],
  //     ),
  //   ));
  // }

  Widget getPageWidget() {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(title),
          actions: const <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        drawer: const MenuDrawer(), //抽屉
        bottomNavigationBar: Builder(builder: (context) {
          return BottomNavigationBar(
            // 底部导航
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_chart_rounded), label: '在留資格審査'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.align_horizontal_left_rounded),
                  label: 'グラフ'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.all_inbox_rounded), label: 'ビザに関す情報'),
            ],
            currentIndex:
                Provider.of<ImmigrationStatisticsModel>(context).selectedIndex,
            onTap: (index) =>
                Provider.of<ImmigrationStatisticsModel>(context, listen: false)
                    .selectedIndex = index,
          );
        }),
        body: OrientationBuilder(builder: (context, orientation) {
          BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
          ImmigrationStatisticsModel isModel =
              Provider.of<ImmigrationStatisticsModel>(context);
          return Column(
            children: [
              if (orientation == Orientation.portrait)
                Container(
                  child: AdWidget(ad: bAdModel.bannerAd()),
                  width: bAdModel.bannerAd().size.width.toDouble(),
                  height: 72.0,
                  alignment: Alignment.center,
                ),
              Expanded(
                  flex: 1,
                  child: () {
                    switch (isModel.selectedIndex) {
                      case 0:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            isModel.model == null
                                ? const Center(child: Text("予想外エラー"))
                                : _cat01ListView(isModel.model!, bAdModel)
                          ],
                        );
                      case 1:
                        return const GraphDataSelectPage();
                      case 2:
                        return const VisaInfoPage();
                      default:
                        return const Center(child: Text("予想外エラー"));
                    }
                  }()),
            ],
          );
        }));
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // COMPLETE: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
