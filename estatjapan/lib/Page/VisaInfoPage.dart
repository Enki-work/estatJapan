import 'package:estatjapan/model/VisaInfoPageData.dart';
import 'package:flutter/material.dart';

class VisaInfoPage extends StatelessWidget {
  const VisaInfoPage({Key? key}) : super(key: key);

  static const visaData = [
    VisaInfoData(
        title: "在留資格認定証明書交付申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-1.html"),
    VisaInfoData(
        title: "在留資格変更許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-2.html"),
    VisaInfoData(
        title: "在留期間更新許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-3.html"),
    VisaInfoData(
        title: "在留資格取得許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-10.html"),
    VisaInfoData(
        title: "永住許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-4.html"),
    VisaInfoData(
        title: "再入国許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-5.html"),
    VisaInfoData(
        title: "難民旅行証明書交付申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-7.html"),
    VisaInfoData(
        title: "資格外活動許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-8.html"),
    VisaInfoData(
        title: "就労資格証明書交付申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-9.html"),
    VisaInfoData(
        title: "仮放免許可申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-11.html"),
    VisaInfoData(
        title: "難民認定申請",
        pageUrlStr:
            "https://www.moj.go.jp/isa/applications/procedures/16-6.html"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        itemCount: visaData.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(visaData[index].title),
              minVerticalPadding: 25,
              onTap: () {
                Navigator.of(context).pushNamed("WebViewPage",
                    arguments: visaData[index].pageUrlStr);
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
