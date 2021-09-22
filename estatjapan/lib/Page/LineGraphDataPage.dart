import 'package:estatjapan/model/GraphData.dart';
import 'package:flutter/material.dart';

class LineGraphDataPage extends StatefulWidget {
  final GraphData graphData;
  const LineGraphDataPage({Key? key, required this.graphData})
      : super(key: key);

  @override
  State<LineGraphDataPage> createState() => _LineGraphDataPageState();
}

class _LineGraphDataPageState extends State<LineGraphDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(
            widget.graphData.selectedCat03Mode!.name +
                "の" +
                widget.graphData.selectedCat01Mode!.name +
                "\n全期間統計折れ線グラフ",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0),
                )
              ],
            ),
            textAlign: TextAlign.center,
          ),
          actions: const <Widget>[
            //导航栏右侧菜单
            // IconButton(icon: Icon(Icons.share), onPressed: () {}),
          ],
        ),
        body: Text("LineGraphDataPage"));
  }
}
