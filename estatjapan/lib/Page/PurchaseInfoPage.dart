// ignore: file_names
import 'package:estatjapan/model/pigeonModel/PurchaseModelApi.dart';
import 'package:flutter/material.dart';

class PurchaseInfoPage extends StatelessWidget {
  const PurchaseInfoPage({Key? key}) : super(key: key);
  static const price = '¥100';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("広告を削除するとは"),
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.only(
                    top: 60, left: 16, right: 16, bottom: 16),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(children: [
                          Image.asset('images/app_icon.png',
                              width: MediaQuery.of(context).size.width * 0.3),
                          const SizedBox(height: 8),
                          const Text(
                            "在留資格統計",
                            style: TextStyle(fontSize: 20),
                          ),
                        ])),
                    Expanded(
                        flex: 2,
                        child: Scrollbar(
                            // 显示进度条
                            child: SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 23, right: 23, bottom: 16),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                46,
                                        child: Card(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16, bottom: 16),
                                              child: Column(children: const [
                                                Text(
                                                  "広告削除プランの機能",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "アプリ内の広告非表示",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )
                                              ])),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      const Text(
                                        "購入の確認・注意点",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Divider(
                                        height: 0.5,
                                        color: Colors.grey[120],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎「自動継続課金」について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "契約期間は、期限が切れる24時間以内に自動更新の解除をされない場合、自動更新されます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎解約方法について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "設定＞Apple ID＞サブスクリプション＞アプリ名＞サブスクリプションからクアンセルで解約ができます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎契約期間の確認",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "解約方法と同じ手順で契約時間の確認いただけます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎購入の復元について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "契約中の場合、購入情報を復元するから、復元することが可能です。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎キャンセルについて",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "当月分のキャンセルはお受けておりません。App Store経由で課金されます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 30),
                                      const Text(
                                        "利用規約・プライバシー",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      Divider(
                                        height: 0.5,
                                        color: Colors.grey[120],
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎利用規約・プライバシーについて",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "第三者に個人を特定できる情報を提供することはできません。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎データ解析について",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "継続的なアプリ改善のため、アクセス解析をしております。解析データは匿名で収集されており、個人を特定するものではありません。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎免責事項",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "利用者が当アプリを使用したことにより生じた、いかなる損失や損害などの被害に関して、開発元は責任を負わないものとします。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        "⚫︎ありがとう",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "最後まできっちり読んでいただいてありがとうございます。",
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ])))),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(
                              MediaQuery.of(context).size.width * 0.7, 60))),
                      icon: const Icon(Icons.send),
                      label: const Text("広告削除課金を申し込む"),
                      onPressed: () async {
                        bool result =
                            await HostPurchaseModelApi().requestPurchaseModel();
                        if (result) Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text("無料期間終了後$price/月")
                  ],
                ))));
  }
}
