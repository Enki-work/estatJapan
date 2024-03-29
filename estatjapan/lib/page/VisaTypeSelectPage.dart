import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../model/jsonModel/ClassOBJ.dart';
import '../model/state/AppConfigState.dart';

class VisaTypeSelectPage extends StatelessWidget {
  final ClassOBJ obj;

  const VisaTypeSelectPage({Key? key, required this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BannerAdModel bAdModel = context.watch<AppConfigState>().bannerAdModel!
      ..loadBannerAd(context);
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text(obj.name),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
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
            return ListTile(
              title: Text(obj.CLASS[index].name),
              minVerticalPadding: 25,
              onTap: () {
                final selectedClass = obj.CLASS[index];
                selectedClass.parentID = obj.id;
                Navigator.pop(context, selectedClass);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 0.5,
            indent: 20,
            color: Colors.grey[120],
          ),
        ))
      ]),
    );
  }
}
