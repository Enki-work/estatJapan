import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0, bottom: 10),
              child: Row(
                children: <Widget>[
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
              child: ListView(
                children: <Widget>[
                  const Divider(height: 0.5),
                  ListTile(
                    title: const Text("その他",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email_rounded),
                    title: const Text('開発者に連絡する'),
                    onTap: () {
                      Navigator.pop(context);
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
                  ListTile(
                    title: const Text("アプリに関して",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded),
                    title: const Text('バージョン'),
                    subtitle: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return Text(snapshot.data?.version ?? "-");
                          }
                        } else {
                          return Text("-");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
