import 'dart:io';

import 'package:collection/collection.dart';
import 'package:estatjapan/Util/Indicator.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../model/jsonModel/Class.dart';
import '../model/jsonModel/ImmigrationStatisticsRoot.dart';
import '../model/jsonModel/Value.dart';
import '../model/state/AppConfigState.dart';
import '../model/state_notifier/APIRepositoryNotifier.dart';

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
  static const double PieChartHeight = 400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(
            widget.graphData.selectedCat03Mode!.name +
                "の" +
                widget.graphData.selectedCat02Mode!.name +
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
            future: context.read<APIRepositoryNotifier>().getData(
                selectedMonth: widget.graphData.selectedMonth!.code,
                selectedCat02: widget.graphData.selectedCat02Mode!.code,
                selectedCat03: widget.graphData.selectedCat03Mode!.code),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                ImmigrationStatisticsRoot rootModel = snapshot.data;
                return _pieChart(rootModel);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SystemChrome.setPreferredOrientations(
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? [DeviceOrientation.portraitUp]
                        : [DeviceOrientation.landscapeRight])
                .then((value) {
              if (Platform.isIOS) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight
                ]);
              }
            });
          },
          child: const Icon(Icons.screen_rotation_rounded),
        ));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  Widget _pieChart(ImmigrationStatisticsRoot rootModel) {
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "cat01")
        .CLASS
        .where((element) => element.level == "1")
        .toList();
    final totalResult = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
        .firstWhere((element) => element.cat01 == models.first.code);
    BannerAdModel bAdModel = context.watch<AppConfigState>().bannerAdModel!
      ..loadBannerAd(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          if (bAdModel.isAdLoaded())
            Container(
              child: AdWidget(ad: bAdModel.bannerAd()),
              width: bAdModel.bannerAd().size.width.toDouble(),
              height: 72.0,
              alignment: Alignment.center,
            ),
          _getShowingSummaryPieChart(models, totalResult, rootModel),
          const SizedBox(
            height: 10,
          ),
          _getShowingReceivedPieChart(models, totalResult, rootModel),
          const SizedBox(
            height: 10,
          ),
          _getShowingSettledPieChart(models, rootModel),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _getShowingSummaryPieChart(List<Class> models, Value totalResult,
      ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.grey.shade200,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            "総数 : "
            "${totalResult.value}${totalResult.unit}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: _GraphDataPageState.PieChartHeight,
            child: ValueListenableProvider<int>.value(
              value: touchedIndex,
              child: totalResult.valueDouble > 0
                  ? Builder(
                      builder: (context) => AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
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
                        ),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "データなし",
                        textAlign: TextAlign.center,
                      )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
    );
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
      final modelCode = models[i + 1].code;
      var resultData = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
          .where((element) => (element.cat01 == modelCode))
          .firstOrNull;
      if (resultData == null && models[i + 1].name == "未済") {
        final existValue =
            rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE.first;
        final doneValue = rootModel
            .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .firstWhere((element) => (element.cat01 ==
                models.firstWhere((element) => element.name == '既済_総数').code));
        final notDone = (int.parse(totalResult.value ?? '') -
                int.parse(doneValue.value ?? ''))
            .toString();
        resultData = Value(
            tab: existValue.tab,
            cat01: models[i + 1].code,
            cat02: existValue.cat02,
            cat03: existValue.cat03,
            time: existValue.time,
            unit: existValue.unit,
            value: notDone);
      }
      return PieChartSectionData(
        color: chartColors[i],
        value: resultData?.valueDouble,
        title:
            '${resultData?.valueDouble.ceil()}${totalResult.unit}\n(${(((resultData?.valueDouble ?? 0) / (totalResult.valueDouble)) * 100.0).ceil()}%)',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    });
  }

  Widget _getShowingReceivedPieChart(List<Class> pModels, Value totalResult,
      ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => (element.id == "cat01"))
        .CLASS
        .where((element) =>
            (element.parentCode == pModels.first.code) ||
            (element.code == pModels.first.code))
        .toList();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.grey.shade200,
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
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: _GraphDataPageState.PieChartHeight,
            child: ValueListenableProvider<int>.value(
              value: touchedIndex,
              child: AspectRatio(
                aspectRatio: 1,
                child: totalResult.valueDouble > 0
                    ? Builder(
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
                            ))
                    : Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "データなし",
                          textAlign: TextAlign.center,
                        )),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
    );
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
          .firstWhere((element) => (element.cat01 == model.code));
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

  Widget _getShowingSettledPieChart(
      List<Class> pModels, ImmigrationStatisticsRoot rootModel) {
    final touchedIndex = ValueNotifier(-1);
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => (element.id == "cat01"))
        .CLASS
        .where((element) =>
            (element.parentCode == pModels[1].code) ||
            (element.code == pModels[1].code))
        .toList();
    final resultData = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
        .firstWhere((element) => (element.cat01 == pModels[1].code));
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.grey.shade200,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Text(
            "${pModels[1].name} : "
            "${resultData.value}${resultData.unit}",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: _GraphDataPageState.PieChartHeight,
            child: ValueListenableProvider<int>.value(
              value: touchedIndex,
              child: AspectRatio(
                aspectRatio: 1,
                child: resultData.valueDouble > 0
                    ? Builder(
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
                                  sections: _showingSettledSections(
                                      Provider.of<int>(context),
                                      rootModel,
                                      models,
                                      resultData)),
                            ))
                    : Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "データなし",
                          textAlign: TextAlign.center,
                        )),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
    );
  }

  List<PieChartSectionData> _showingSettledSections(
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
          .firstWhere((element) => (element.cat01 == model.code));
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
