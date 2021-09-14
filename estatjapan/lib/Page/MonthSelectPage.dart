import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

enum MonthSelectPageType { old, graph }

class MonthSelectPage extends StatelessWidget {
  final MonthSelectPageType pageType;
  final ClassOBJ? monthClassObj;
  final RouteModel? routeModel;

  const MonthSelectPage(
      {Key? key, this.routeModel, required this.pageType, this.monthClassObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Null Function(int index) itemOnTap;
    ClassOBJ obj;
    if (pageType == MonthSelectPageType.old) {
      ClassOBJ? classOBJ = routeModel!
          .rootModel?.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((e) => e.id == "time");
      if (classOBJ == null) return const Center(child: Text("予想外エラー"));
      itemOnTap = (int index) {
        routeModel!.selectedMonth = classOBJ.CLASS[index];
        routeModel!.selectedMonth!.parentID = classOBJ.id;
        Navigator.of(context).pushNamed("DataTablePage", arguments: routeModel);
      };
      obj = classOBJ;
    } else {
      ClassOBJ? classOBJ = monthClassObj;
      if (classOBJ == null) return const Center(child: Text("予想外エラー"));
      itemOnTap = (int index) {
        final selectedClass = classOBJ.CLASS[index];
        selectedClass.parentID = classOBJ.id;
        Navigator.pop(context, selectedClass);
      };
      obj = classOBJ;
    }
    return ChangeNotifierProvider<BannerAdModel>(
      create: (_) => BannerAdModel()..loadBannerAd(),
      child: Scaffold(
          appBar: AppBar(
            //导航栏
            title: Text(obj.name),
          ),
          body: Builder(
            builder: (context) {
              BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      itemCount: bAdModel.isAdLoaded()
                          ? obj.CLASS.length + 1
                          : obj.CLASS.length,
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
                        return ListTile(
                          title: Text(obj.CLASS[index].name),
                          minVerticalPadding: 25,
                          onTap: () {
                            itemOnTap(index);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        height: 0.5,
                        indent: 20,
                        color: Colors.grey[120],
                      ),
                    ))
                  ]);
            },
          )),
    );
  }
}
