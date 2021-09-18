import 'package:dio/dio.dart';
import 'package:estatjapan/Util/Indicator.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphDataPage extends StatefulWidget {
  final GraphData graphData;
  const GraphDataPage({Key? key, required this.graphData}) : super(key: key);

  @override
  State<GraphDataPage> createState() => _GraphDataPageState();
}

class _GraphDataPageState extends State<GraphDataPage> {
  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(
            widget.graphData.selectedCat03Mode!.name +
                "の" +
                widget.graphData.selectedCat01Mode!.name +
                "\n(${widget.graphData.selectedCat02Mode!.name})統計グラフ",
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
        body: FutureBuilder(
            future: _dio.get(widget.graphData.url),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                Response response = snapshot.data;
                ImmigrationStatisticsRoot rootModel =
                    ImmigrationStatisticsRoot.fromJson(response.data);
                return _pieChart(rootModel);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _pieChart(ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ValueListenableProvider<int>.value(
                      value: touchedIndex,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Builder(
                            builder: (context) => PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(touchCallback:
                                          (FlTouchEvent event,
                                              pieTouchResponse) {
                                        if (!event
                                                .isInterestedForInteractions ||
                                            pieTouchResponse == null ||
                                            pieTouchResponse.touchedSection ==
                                                null) {
                                          touchedIndex.value = -1;
                                          return;
                                        }
                                        print(
                                            "!!!!!!${pieTouchResponse.touchedSection!.touchedSectionIndex}");
                                        touchedIndex.value = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      }),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 50,
                                      sections: _showingSections(
                                          Provider.of<int>(context))),
                                )),
                      )),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Indicator(
                              color: Color(0xff0293ee),
                              text: 'First',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xfff8b250),
                              text: 'Second',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff845bef),
                              text: 'Third',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Indicator(
                              color: Color(0xff13d38e),
                              text: 'Fourth',
                              isSquare: true,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ))),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          )),
    );
  }

  List<PieChartSectionData> _showingSections(int touchedIndex) {
    print("!!!!!!$touchedIndex");
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 17.0;
      final radius = isTouched ? 110.0 : 90.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}

// removeDummy()
// 'var eee = document.getElementById('\(elementID)'); eee.parentElement.removeChild(element);'
