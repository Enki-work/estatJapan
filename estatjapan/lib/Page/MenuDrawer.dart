import 'package:flutter/material.dart';

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
