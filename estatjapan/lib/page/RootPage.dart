import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../model/jsonModel/Class.dart';
import '../model/jsonModel/ClassOBJ.dart';
import '../model/jsonModel/ImmigrationStatisticsRoot.dart';
import '../model/state/AppConfigState.dart';
import '../model/state/RootPageState.dart';
import '../model/state_notifier/RootPageNotifier.dart';

class RootPage extends StatelessWidget {
  final String title;
  const RootPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StateNotifierProvider<RootPageNotifier, RootPageState>(
        create: (_) => RootPageNotifier(),
      ),
      ChangeNotifierProvider<BannerAdModel>(create: (_) => BannerAdModel()),
    ], child: _RootPageBody(title));
  }
}

class _RootPageBody extends StatelessWidget {
  final String title;

  const _RootPageBody(this.title);

  Widget _body(BuildContext context) {
    context
        .read<RootPageNotifier>()
        .getMenuData(context.watch<AppConfigState>().estatAppId);
    return getPageWidget(context);
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

  Widget getPageWidget(BuildContext context) {
    context.read<BannerAdModel>().loadBannerAd(context);
    final bAdModel = context.watch<BannerAdModel>();
    return OrientationBuilder(builder: (context, orientation) {
      final rootPageState = context.watch<RootPageState>();
      return Column(
        children: [
          if (orientation == Orientation.portrait && bAdModel.isAdLoaded())
            Container(
              child: AdWidget(ad: bAdModel.bannerAd()),
              width: double.infinity,
              height: 72.0,
              alignment: Alignment.center,
            ),
          if (rootPageState.immigrationStatisticsRoot != null)
            Expanded(
                flex: 1,
                child: () {
                  switch (rootPageState.selectedIndex) {
                    case 0:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _cat01ListView(
                              rootPageState.immigrationStatisticsRoot!,
                              bAdModel)
                        ],
                      );
                    // case 1:
                    //   return const GraphDataSelectPage();
                    // case 2:
                    //   return const VisaInfoPage();
                    default:
                      return const Center(child: Text("予想外エラー"));
                  }
                }()),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
      body: _body(context),
      bottomNavigationBar: Builder(builder: (context) {
        return BottomNavigationBar(
          // 底部导航
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart_rounded), label: '在留資格審査'),
            BottomNavigationBarItem(
                icon: Icon(Icons.align_horizontal_left_rounded), label: 'グラフ'),
            BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox_rounded), label: 'ビザに関する情報'),
          ],
          currentIndex: context.watch<RootPageState>().selectedIndex,
          onTap: (index) =>
              context.read<RootPageNotifier>().selectedIndex = index,
        );
      }),
    );
  }
}
