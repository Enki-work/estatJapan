import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String? loadUrl;
  const WebViewPage({Key? key, required this.loadUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? _webViewController;
  var _title = "";

  @override
  Widget build(BuildContext context) {
    if (widget.loadUrl?.isEmpty ?? true) {
      Navigator.of(context).pop();
      return const SizedBox();
    }
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(_title),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
          shadowColor: Theme.of(context).primaryColor.withOpacity(0),
          actions: const <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: WebView(
            initialUrl: widget.loadUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            onPageFinished: (String url) {
              // final js = 'function removeDummy() {'
              //     'var elem = document.getElementById("wrapper");'
              //     'var childs = elem.childnodes;'
              //     // 'Array.prototype.forEach.call(childs, function(child) {'
              //     // 'child.parentElement.removeChild(child);'
              //     // '});'
              //     // 'var a1 = document.getElementsByClassName("titlePage");'
              //     // 'a1.parentElement.removeChild(a1);'
              //
              //     //
              //     // 'var eee = document.getElementsByClassName("textBlock honbun");'
              //     // 'Array.prototype.forEach.call(eee, function(child) {'
              //     // 'child.parentElement.removeChild(child);'
              //     // '});'
              //
              //     'var eee = document.getElementById("contentsArea");'
              //     'Array.prototype.forEach.call(eee.children, function(child) {'
              //     'Array.prototype.forEach.call(child.children, function(childi) {'
              //     'childi.parentElement.removeChild(childi);'
              //     '});'
              //     '});'
              //
              //     // 'var eee = document.getElementById("contentsArea"); eee.parentElement.removeChild(eee);'
              //     '}removeDummy();';
              _webViewController!
                  .runJavascriptReturningResult(("document.title"))
                  .then((value) => setState(() {
                        _title = value;
                      }));
            }));
  }
}

// removeDummy()
// 'var eee = document.getElementById('\(elementID)'); eee.parentElement.removeChild(element);'
