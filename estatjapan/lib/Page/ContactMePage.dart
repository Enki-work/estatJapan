import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactMePage extends StatelessWidget {
  const ContactMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("開発者に連絡する"),
        ),
        body: Container(
            padding:
                const EdgeInsets.only(top: 26, left: 16, right: 16, bottom: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'images/stat.svg',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 26),
                const Text(
                  "このサービスは、政府統計総合窓口(e-Stat)のAPI機能を使用していますが、サービスの内容は国によって保証されたものではありません。",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )));
  }
}
