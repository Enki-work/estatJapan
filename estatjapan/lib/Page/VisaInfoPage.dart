import 'package:flutter/material.dart';

class VisaInfoPage extends StatelessWidget {
  const VisaInfoPage({Key? key}) : super(key: key);

  static const visaData = {
    "在留資格認定証明書交付申請":
        "https://www.moj.go.jp/isa/applications/procedures/16-10.html",
    "在留資格変更許可申請": "https://www.moj.go.jp/isa/applications/procedures/16-2.html",
    "在留期間更新許可申請": "https://www.moj.go.jp/isa/applications/procedures/16-3.html",
    "在留資格取得許可申請":
        "https://www.moj.go.jp/isa/applications/procedures/16-10.html",
    "永住許可申請": "https://www.moj.go.jp/isa/applications/procedures/16-4.html",
    "再入国許可申請": "https://www.moj.go.jp/isa/applications/procedures/16-5.html",
  };

  @override
  Widget build(BuildContext context) {
    final visaDataKeyList = visaData.keys.toList();
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        itemCount: visaDataKeyList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(visaDataKeyList[index]),
              minVerticalPadding: 25,
              onTap: () {
                Navigator.of(context).pushNamed("WebViewPage",
                    arguments: visaData[visaDataKeyList[index]]);
              });
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0.5,
          indent: 20,
          color: Colors.grey[120],
        ),
      ))
    ]);
  }
}
