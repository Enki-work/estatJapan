import 'package:estatjapan/Util/AppConfig.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

enum SettingPageItemType { themeFollowSystem, themeDarkMode }

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const List listItemTitles = [
    SettingPageItemType.themeDarkMode,
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
                        switch (itemType) {
                          case SettingPageItemType.themeDarkMode:
                            final isThemeFollowSystem =
                                AppConfig.shared.isThemeFollowSystem;
                            final isThemeDarkMode =
                                AppConfig.shared.isThemeDarkMode;
                            return Column(
                              children: [
                                const Divider(height: 0.5),
                                const ListTile(
                                  title: Text("ダークモード",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ),
                                ListTile(
                                  title: const Text("システム設定に従う"),
                                  minVerticalPadding: 25,
                                  trailing: Switch(
                                    value: isThemeFollowSystem,
                                    onChanged: (value) {
                                      setState(() {
                                        AppConfig.shared
                                            .setThemeFollowSystem(value);
                                      });
                                    },
                                  ),
                                  onTap: null,
                                ),
                                isThemeFollowSystem
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          ListTile(
                                            title: const Text("ライトモード"),
                                            minVerticalPadding: 25,
                                            trailing: Checkbox(
                                              value: !isThemeDarkMode,
                                              onChanged: (value) {
                                                setState(() {
                                                  AppConfig.shared
                                                      .setThemeDarkModeKey(
                                                          !(value ?? true));
                                                  MaterialApp
                                                });
                                              },
                                            ),
                                            onTap: null,
                                          ),
                                          ListTile(
                                            title: const Text("ダークモード"),
                                            minVerticalPadding: 25,
                                            trailing: Checkbox(
                                              value: isThemeDarkMode,
                                              onChanged: (value) {
                                                setState(() {
                                                  AppConfig.shared
                                                      .setThemeDarkModeKey(
                                                      value ?? false);
                                                });
                                              },
                                            ),
                                            onTap: null,
                                          ),
                                        ],
                                      ),
                              ],
                            );
                        }

                        return const ListTile();
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
