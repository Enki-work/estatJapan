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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            model.rootModel = rootModel;
            return FutureBuilder<InitializationStatus>(
                future: _initGoogleMobileAds(),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.done
                    ? getPageWidget()
                    : Scaffold(
                        appBar: AppBar(
                          //?????????
                          title: Text(widget.title),
                        ),
                        body:
                            const Center(child: CircularProgressIndicator())));
          } else {
//????????????????????????loading
            return Scaffold(
                appBar: AppBar(
                  //?????????
                  title: Text(widget.title),
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
      itemCount:
          bAdModel.isAdLoaded() ? obj.CLASS.length + 1 : obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int oIndex) {
        int index = bAdModel.isAdLoaded() ? oIndex - 1 : oIndex;
        if (oIndex == 0 && bAdModel.isAdLoaded()) {
          return Container(
            child: AdWidget(ad: bAdModel.bannerAd()),
            width: bAdModel.bannerAd().size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
          );
        }
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

  Widget _cat02ListView(
      ImmigrationStatisticsRoot rootModel, BannerAdModel bAdModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat02");
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount:
          bAdModel.isAdLoaded() ? obj.CLASS.length + 1 : obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int oIndex) {
        int index = bAdModel.isAdLoaded() ? oIndex - 1 : oIndex;
        if (oIndex == 0 && bAdModel.isAdLoaded()) {
          return Container(
            child: AdWidget(ad: bAdModel.bannerAd()),
            width: bAdModel.bannerAd().size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
          );
        }
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

  Widget _cat03ListView(
      ImmigrationStatisticsRoot rootModel, BannerAdModel bAdModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat03");
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount:
          bAdModel.isAdLoaded() ? obj.CLASS.length + 1 : obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int oIndex) {
        int index = bAdModel.isAdLoaded() ? oIndex - 1 : oIndex;
        if (oIndex == 0 && bAdModel.isAdLoaded()) {
          return Container(
            child: AdWidget(ad: bAdModel.bannerAd()),
            width: bAdModel.bannerAd().size.width.toDouble(),
            height: 72.0,
            alignment: Alignment.center,
          );
        }
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

  Widget getPageWidget() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ImmigrationStatisticsModel>.value(
              value: model),
          ChangeNotifierProvider<BannerAdModel>(
              create: (_) => BannerAdModel()..loadBannerAd()),
        ],
        child: Scaffold(
            appBar: AppBar(
              //?????????
              title: Text(widget.title),
              actions: const <Widget>[
                //?????????????????????
                // IconButton(icon: Icon(Icons.share), onPressed: () {}),
              ],
            ),
            drawer: const MenuDrawer(), //??????
            bottomNavigationBar: Builder(builder: (context) {
              return BottomNavigationBar(
                // ????????????
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_chart_rounded), label: '??????????????????'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.align_horizontal_left_rounded),
                      label: '?????????????????????'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.all_inbox_rounded), label: '????????????????????????'),
                ],
                currentIndex: Provider.of<ImmigrationStatisticsModel>(context)
                    .selectedIndex,
                onTap: (index) => model.selectedIndex = index,
              );
            }),
            body: Builder(builder: (context) {
              BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
              ImmigrationStatisticsModel isModel =
                  Provider.of<ImmigrationStatisticsModel>(context);
              switch (isModel.selectedIndex) {
                case 0:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      isModel.model == null
                          ? const Center(child: Text("??????????????????"))
                          : _cat01ListView(isModel.model!, bAdModel)
                    ],
                  );
                case 1:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      isModel.model == null
                          ? const Center(child: Text("??????????????????"))
                          : _cat02ListView(isModel.model!, bAdModel)
                    ],
                  );
                case 2:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      isModel.model == null
                          ? const Center(child: Text("??????????????????"))
                          : _cat03ListView(isModel.model!, bAdModel)
                    ],
                  );
                default:
                  return const Center(child: Text("??????????????????"));
              }
            })));
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // COMPLETE: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }
}
