import 'package:estatjapan/model/state_notifier/AppConfigNotifier.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../model/state/AppConfigState.dart';

enum SettingPageItemType { themeDarkMode, themeColorSetting }

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const List listItemTitles = [
    SettingPageItemType.themeDarkMode,
    SettingPageItemType.themeColorSetting,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: const Text("設定"),
      ),
      body: Builder(
        builder: (context) {
          final bAdModel = context.watch<AppConfigState>().bannerAdModel!
            ..loadBannerAd(context);
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    return themeDarkModeItem(context);
                  case SettingPageItemType.themeColorSetting:
                    return themeColorSettingItem(context);
                }

                return const ListTile();
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0.5,
                indent: 20,
                color: Colors.grey[120],
              ),
            ))
          ]);
        },
      ),
    );
  }

  Widget themeDarkModeItem(BuildContext context) {
    final isThemeFollowSystem =
        context.watch<AppConfigState>().isThemeFollowSystem;
    final isThemeDarkMode = context.watch<AppConfigState>().isThemeDarkMode;
    return Column(
      children: [
        const Divider(height: 0.5),
        const ListTile(
          title: Text("ダークモード",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        ListTile(
          title: const Text("システム設定に従う"),
          minVerticalPadding: 25,
          trailing: Switch(
            value: isThemeFollowSystem,
            onChanged: (value) {
              context.read<AppConfigNotifier>().setThemeFollowSystem(value);
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
                        context
                            .read<AppConfigNotifier>()
                            .setThemeDarkModeKey(false);
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
                        context
                            .read<AppConfigNotifier>()
                            .setThemeDarkModeKey(true);
                      },
                    ),
                    onTap: null,
                  ),
                ],
              ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget themeColorSettingItem(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0.5),
        const ListTile(
          title: Text("テーマカラー設定",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        ...FlexScheme.values
            .map(
              (e) => RadioListTile(
                secondary: Icon(
                  Icons.color_lens,
                  color: FlexThemeData.light(scheme: e).primaryColorLight,
                ),
                title: Text(e.name),
                value: e.name,
                groupValue:
                    context.watch<AppConfigState>().themeFlexScheme.name,
                onChanged: (String? value) => context
                    .read<AppConfigNotifier>()
                    .themeFlexSchemeName = value ?? '',
                selected: e.name ==
                    context.watch<AppConfigState>().themeFlexScheme.name,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            )
            .toList(),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
