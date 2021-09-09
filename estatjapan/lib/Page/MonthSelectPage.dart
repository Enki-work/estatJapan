import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class MonthSelectPage extends StatelessWidget {
  final RouteModel routeModel;

  const MonthSelectPage({Key? key, required this.routeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClassOBJ? obj = routeModel
        .rootModel?.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "time");
    if (obj == null) return Center(child: Text("予想外エラー"));
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
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                            this.routeModel.selectedMonth = obj.CLASS[index];
                            this.routeModel.selectedMonth!.parentID = obj.id;
                            Navigator.of(context).pushNamed("DataTablePage",
                                arguments: this.routeModel);
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
