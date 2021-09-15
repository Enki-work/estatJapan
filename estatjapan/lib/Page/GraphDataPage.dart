import 'package:estatjapan/model/GraphData.dart';
import 'package:flutter/material.dart';

class GraphDataPage extends StatefulWidget {
  final GraphData graphData;
  const GraphDataPage({Key? key, required this.graphData}) : super(key: key);

  @override
  State<GraphDataPage> createState() => _GraphDataPageState();
}

class _GraphDataPageState extends State<GraphDataPage> {
  @override
  Widget build(BuildContext context) {
    if (!widget.graphData.isModelExist()) {
      Navigator.of(context).pop();
      return const SizedBox();
    }
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: const Text("グラフ"),
          actions: const <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        body: Text("aaaa"));
  }
}

// removeDummy()
// 'var eee = document.getElementById('\(elementID)'); eee.parentElement.removeChild(element);'
