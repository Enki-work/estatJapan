import 'package:estatjapan/model/VisaInfoPageData.dart';
import 'package:flutter/material.dart';

class VisaInfoPage extends StatelessWidget {
  const VisaInfoPage({Key? key, this.visaInfoPageData}) : super(key: key);
  final VisaInfoPageData? visaInfoPageData;

  @override
  Widget build(BuildContext context) {
    if (visaInfoPageData == null) {
      return VisaInfoColumn(
        visaInfoPageData: visaInfoPageData,
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            //导航栏
            title: Text(visaInfoPageData!.title),
          ),
          body: VisaInfoColumn(
            visaInfoPageData: visaInfoPageData,
          ));
    }
  }
}

class VisaInfoColumn extends StatelessWidget {
  const VisaInfoColumn({Key? key, this.visaInfoPageData}) : super(key: key);
  final VisaInfoPageData? visaInfoPageData;
  List get visaData => visaInfoPageData?.pageData ?? defaultVisaData;
  static const List defaultVisaData = [
    VisaInfoPageData(title: "永住許可に関する", pageData: [
      VisaInfoData(
          title: "永住許可申請",
          pageUrlStr:
              "https://www.moj.go.jp/isa/applications/procedures/16-4.html"),
      VisaInfoData(
          title: "永住許可申請書の様式の記入例・書き方の見本・サンプル",
          pageUrlStr: "http://work-visa.jp/how-to-write/permanent-residence"),
      VisaInfoData(
          title: "高度人材ポイント制とは",
          pageUrlStr:
              "https://www.moj.go.jp/isa/publications/materials/newimmiact_3_system_index.html"),
      VisaInfoData(
          title: "高度人材ポイント制評価仕組み",
          pageUrlStr: "https://www.moj.go.jp/isa/content/930001655.pdf"),
      VisaInfoData(
          title: "高度専門職ビザから永住申請書類リスト（中国語）",
          pageUrlStr:
              "https://docs.google.com/spreadsheets/d/1CEHenEdRqznMaVJnG4JbaVce3EMQkQqZYhAGqFNCUQU/edit?usp=sharing"),
      VisaInfoData(
          title: "永住理由書書き方サンプル（中国語）", pageUrlStr: "http://xhslink.com/Ns5kFe"),
    ]),
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
          final data = visaData[index];
          if (data is VisaInfoPageData) {
            return ListTile(
                title: Text(data.title),
                minVerticalPadding: 25,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("VisaInfoPage", arguments: data);
                });
          } else if (data is VisaInfoData) {
            return ListTile(
                title: Text(data.title),
                minVerticalPadding: 25,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed("WebViewPage", arguments: data.pageUrlStr);
                });
          } else {
            return const ListTile();
          }
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
