import 'package:dio/dio.dart';
import 'package:estatjapan/Util/Indicator.dart';
import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/Value.dart';
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
  static const List<Color> chartColors = <Color>[
    Colors.red,
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Colors.brown,
    Colors.indigo,
    Colors.lime,
    Colors.green,
  ];
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
                "\n(${widget.graphData.selectedMonth!.name})統計グラフ",
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
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "cat02")
        .CLASS
        .where((element) => element.level == "1")
        .toList();
    final totalResult = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
        .firstWhere((element) => element.cat02 == models.first.code);

    return SafeArea(
        child: ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _getShowingSummaryPieChart(models, totalResult, rootModel),
        _getShowingReceivedPieChart(models, totalResult, rootModel)
      ],
    ));
  }

  Widget _getShowingSummaryPieChart(List<Class> models, Value totalResult,
      ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    return AspectRatio(
        aspectRatio: 0.9,
        child: Card(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                "${models.first.name} : "
                "${totalResult.value}${totalResult.unit}",
                style: const TextStyle(fontSize: 18),
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
                                        (FlTouchEvent event, pieTouchResponse) {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex.value = -1;
                                        return;
                                      }
                                      touchedIndex.value = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    }),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                    sections: _showingSummarySections(
                                        Provider.of<int>(context),
                                        rootModel,
                                        models,
                                        totalResult)),
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
                        children: models
                            .where((element) => models.indexOf(element) != 0)
                            .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Indicator(
                                  color: chartColors[models.indexOf(e) - 1],
                                  text: e.name,
                                  isSquare: true,
                                )))
                            .toList(),
                      ))),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ));
  }

  Widget _getShowingReceivedPieChart(List<Class> pModels, Value totalResult,
      ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "cat02")
        .CLASS
        .where((element) =>
            (element.parentCode == pModels.first.code) ||
            (element.code == pModels.first.code))
        .toList();
    return AspectRatio(
        aspectRatio: 0.9,
        child: Card(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                "${models.first.name} : "
                "${totalResult.value}${totalResult.unit}",
                style: const TextStyle(fontSize: 18),
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
                                        (FlTouchEvent event, pieTouchResponse) {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex.value = -1;
                                        return;
                                      }
                                      touchedIndex.value = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    }),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                    sections: _showingReceivedSections(
                                        Provider.of<int>(context),
                                        rootModel,
                                        models,
                                        totalResult)),
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
                        children: models
                            .where((element) => models.indexOf(element) != 0)
                            .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Indicator(
                                  color: chartColors[models.indexOf(e) - 1],
                                  text: e.name,
                                  isSquare: true,
                                )))
                            .toList(),
                      ))),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ));
  }

  List<PieChartSectionData> _showingReceivedSections(
      int touchedIndex,
      ImmigrationStatisticsRoot rootModel,
      List<Class> models,
      Value totalResult) {
    if (models.length < 2) {
      return [];
    }
    models.sort((a, b) => a.code.compareTo(b.code));
    return List.generate(models.length - 1, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 17.0;
      final radius = isTouched ? 110.0 : 90.0;
      final model = models[i + 1];
      final resultData = rootModel
          .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
          .firstWhere((element) => element.cat02 == model.code);
      return PieChartSectionData(
        color: chartColors[i],
        value: resultData.valueDouble,
        title:
            '${resultData.valueDouble.ceil()}${totalResult.unit}\n(${(resultData.valueDouble / totalResult.valueDouble * 100).ceil()}%)',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  List<PieChartSectionData> _showingSummarySections(
      int touchedIndex,
      ImmigrationStatisticsRoot rootModel,
      List<Class> models,
      Value totalResult) {
    if (models.length < 2) {
      return [];
    }
    models.sort((a, b) => a.code.compareTo(b.code));
    return List.generate(models.length - 1, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 17.0;
      final radius = isTouched ? 110.0 : 90.0;
      final model = models[i + 1];
      final resultData = rootModel
          .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
          .firstWhere((element) => element.cat02 == model.code);
      return PieChartSectionData(
        color: chartColors[i],
        value: resultData.valueDouble,
        title:
            '${resultData.valueDouble.ceil()}${totalResult.unit}\n(${(resultData.valueDouble / totalResult.valueDouble * 100).ceil()}%)',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }
}

// removeDummy()
// 'var eee = document.getElementById('\(elementID)'); eee.parentElement.removeChild(element);'
