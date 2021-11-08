import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/util/AppConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

enum SettingPageItemType { darkMode }

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const List listItemTitles = [
    SettingPageItemType.darkMode,
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BannerAdModel>(
      create: (_) => BannerAdModel()..loadBannerAd(),
      child: Scaffold(
          appBar: AppBar(
            //导航栏
            title: const Text("設定"),
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
                          ? listItemTitles.length + 1
                          : listItemTitles.length,
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
                        final itemType = listItemTitles[index];
                        ListTile listTile = const ListTile();
                        switch (itemType) {
                          case SettingPageItemType.darkMode:
                            listTile = ListTile(
                              title: const Text("ダークモード"),
                              minVerticalPadding: 25,
                              // trailing: const Text(
                              //   "システム設定に従う",
                              // ),
                              subtitle: const Text(
                                "システム設定に従う",
                              ),
                              trailing: Switch(
                                value: AppConfig.shared.isThemeDarkMode,
                                onChanged: (value) {
                                  //重新构建页面
                                  setState(() {
                                    AppConfig.shared.setThemeDarkModeKey(value);
                                  });
                                },
                              ),
                              onTap: () {
                                // itemOnTap(index);
                              },
                            );
                            break;
                        }

                        return listTile;
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
