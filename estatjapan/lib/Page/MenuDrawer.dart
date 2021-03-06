import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/pigeonModel/PurchaseModelApi.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: MediaQuery.removePadding(
      context: context,
      //移除抽屉菜单顶部默认留白
      removeTop: true,
      child: ChangeNotifierProvider<BannerAdModel>(
          create: (_) => BannerAdModel()..loadBannerAd(),
          child: Builder(builder: (context) {
            BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 38.0, bottom: 10),
                  child: Row(
                    children: const <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: ClipOval(
                      //     child: Image().asset(
                      //       "imgs/avatar.png",
                      //       width: 80,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "在留資格取得等統計",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      const Divider(height: 0.5),
                      const ListTile(
                        title: Text('課金',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      bAdModel.isPurchase()
                          ? const ListTile(
                              leading: Icon(Icons.check_circle_rounded),
                              title: Text('広告削除済み'),
                              onTap: null,
                            )
                          : Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                      Icons.account_balance_wallet_rounded),
                                  title: const Text('広告を削除する'),
                                  onTap: () {
                                    Navigator.pop(context);

                                    Navigator.of(context)
                                        .pushNamed("PurchaseInfoPage");
                                  },
                                ),
                                ListTile(
                                  leading:
                                      const Icon(Icons.monetization_on_rounded),
                                  title: const Text('支払い済課金復元'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    HostPurchaseModelApi()
                                        .restorePurchaseModel();
                                  },
                                ),
                              ],
                            ),
                      const ListTile(
                        title: Text("設定",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('設定'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("SettingPage");
                        },
                      ),
                      const Divider(height: 0.5),
                      const ListTile(
                        title: Text("その他",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email_rounded),
                        title: const Text('開発者に連絡する'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("ContactMePage");
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.archive_rounded),
                        title: const Text('ライセンス情報'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("LicenseInfoPage");
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.article_rounded),
                        title: const Text('データ提供元'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("eStaInfoPage");
                        },
                      ),
                      const Divider(height: 0.5),
                      const ListTile(
                        title: Text("アプリに関して",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded),
                        title: const Text('バージョン'),
                        subtitle: FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                return Text(snapshot.data?.version ?? "-");
                              }
                            } else {
                              return const Text("-");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (bAdModel.isAdLoaded())
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: SizedBox(
                          height: bAdModel.bannerAd().size.height.toDouble(),
                          width: bAdModel.bannerAd().size.width.toDouble(),
                          child: AdWidget(ad: bAdModel.bannerAd()))),
              ],
            );
          })),
    ));
  }
}
