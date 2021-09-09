import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactMePage extends StatelessWidget {
  const ContactMePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("開発者に連絡する"),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(
                    top: 26, left: 16, right: 16, bottom: 16),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('images/daqige_icon.png',
                        width: MediaQuery.of(context).size.width * 0.4),
                    const SizedBox(height: 8),
                    const Text(
                      "大旗哥在日本",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 26),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(Size(
                              MediaQuery.of(context).size.width * 0.5, 60))),
                      icon: Icon(Icons.send),
                      label: Text("メール送信"),
                      onPressed: () async {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final info = await PackageInfo.fromPlatform();
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'daqige2333@example.com',
                          query: encodeQueryParameters(<String, String>{
                            'subject': '${info.appName}_V${info.version}'
                          }),
                        );
                        launch(emailLaunchUri.toString());
                      },
                    ),
                    const SizedBox(height: 26),
                    TextButton.icon(
                      icon: Icon(Icons.smart_display_rounded),
                      label: Text("YouTube チャンネル"),
                      onPressed: () {
                        _launchURL(
                            "https://www.youtube.com/channel/UCGZZz9-uu4lEtTZgQxLXZrA");
                      },
                    ),
                    const SizedBox(height: 26),
                    TextButton.icon(
                      icon: Icon(Icons.featured_video_rounded),
                      label: Text("哔哩哔哩 チャンネル"),
                      onPressed: () {
                        _launchURL("https://space.bilibili.com/2025165032");
                      },
                    ),
                    const SizedBox(height: 26),
                    TextButton.icon(
                      icon: Icon(Icons.play_circle_fill_rounded),
                      label: Text("西瓜视频 チャンネル"),
                      onPressed: () {
                        _launchURL("https://www.ixigua.com/home/111243308299");
                      },
                    ),
                  ],
                ))));
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
