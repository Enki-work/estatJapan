import 'dart:io';

import 'package:dio/dio.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

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
    Dio _dio = Dio();
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
        body: FutureBuilder(
            future: _dio.get(widget.graphData.urlWithoutMonth),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                Response response = snapshot.data;
                ImmigrationStatisticsRoot rootModel =
                    ImmigrationStatisticsRoot.fromJson(response.data);
                return _lineChart(rootModel);
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

  Widget _lineChart(ImmigrationStatisticsRoot rootModel) {
    return ChangeNotifierProvider<BannerAdModel>(
        create: (_) => BannerAdModel()..loadBannerAd(),
        child: SafeArea(child: Builder(builder: (context) {
          BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              if (bAdModel.isAdLoaded())
                Container(
                  child: AdWidget(ad: bAdModel.bannerAd()),
                  width: bAdModel.bannerAd().size.width.toDouble(),
                  height: 72.0,
                  alignment: Alignment.center,
                ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "${widget.graphData.selectedCat01Mode!.name}の毎月許可率",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 110),
                height: 360,
                child: LineChart(
                  passRateData(rootModel),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "${widget.graphData.selectedCat01Mode!.name}の毎月新規受理数",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 110),
                height: 360,
                child: LineChart(
                  newApplicationData(rootModel),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "${widget.graphData.selectedCat01Mode!.name}の毎月既済数",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 110),
                height: 360,
                child: LineChart(
                  argeedApplicationData(rootModel),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "${widget.graphData.selectedCat01Mode!.name}の毎月未済数",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 110),
                height: 360,
                child: LineChart(
                  waitingApplicationData(rootModel),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              )
            ],
          );
        })));
  }

  LineChartData passRateData(ImmigrationStatisticsRoot rootModel) {
    final timeModels = rootModel
        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "time")
        .CLASS
        .toList();
    timeModels.sort((left, right) => left.code.compareTo(right.code));
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          margin: 0,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            return timeModels[value.toInt()].name.characters.join("\n");
          },
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 100:
                return '100%';
              case 75:
                return '75%';
              case 25:
                return '25%';
              case 50:
                return '50%';
            }
            return '';
          },
          showTitles: true,
          margin: 0,
          interval: 1,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
            isCurved: true,
            curveSmoothness: 0,
            colors: const [Color(0xff4af699)],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: timeModels.map((e) {
              final value = rootModel
                  .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
                  .where((element) => element.time == e.code);
              if (value
                      .firstWhere((element) => element.cat02 == "00200")
                      .valueDouble ==
                  0) {
                return FlSpot(timeModels.indexOf(e).toDouble(), 0);
              } else {
                final rate = value
                        .firstWhere((element) => element.cat02 == "00201")
                        .valueDouble /
                    value
                        .firstWhere((element) => element.cat02 == "00200")
                        .valueDouble;
                return FlSpot(timeModels.indexOf(e).toDouble(),
                    (rate * 1000).toInt() / 10.toDouble());
              }
            }).toList()),
        // lineChartBarData2_2,
        // lineChartBarData2_3,
      ],
      minX: 0,
      maxX: timeModels.length.toDouble() - 1,
      maxY: 100,
      minY: 0,
    );
  }

  LineChartData newApplicationData(ImmigrationStatisticsRoot rootModel) {
    final timeModels = rootModel
        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "time")
        .CLASS
        .toList();
    timeModels.sort((left, right) => left.code.compareTo(right.code));
    final newApplicationMaxY = () {
      var maxY = 0.0;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00102")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (maxY < values.last.valueDouble) {
          maxY = values.last.valueDouble;
        }
      }
      return maxY;
    }();

    final newApplicationMinY = () {
      var minY = double.infinity;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00102")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (minY > values.first.valueDouble) {
          minY = values.first.valueDouble;
        }
      }
      return minY * 0.96;
    }();
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          margin: 0,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            return timeModels[value.toInt()].name.characters.join("\n");
          },
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          getTitles: (value) {
            final interval = newApplicationMaxY - newApplicationMinY;
            if (value.toInt() == newApplicationMinY.toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() == (newApplicationMaxY - 1).toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() ==
                ((interval / 2) + newApplicationMinY).toInt()) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
          showTitles: true,
          margin: 0,
          interval: 1,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
            isCurved: true,
            curveSmoothness: 0,
            colors: const [Color(0xff4af699)],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: timeModels.map((e) {
              final value = rootModel
                  .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
                  .where((element) =>
                      element.time == e.code && element.cat02 == "00102");
              return FlSpot(
                  timeModels.indexOf(e).toDouble(), value.first.valueDouble);
            }).toList()),
      ],
      minX: 0,
      maxX: timeModels.length.toDouble() - 1,
      maxY: newApplicationMaxY,
      minY: newApplicationMinY,
    );
  }

  LineChartData argeedApplicationData(ImmigrationStatisticsRoot rootModel) {
    final timeModels = rootModel
        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "time")
        .CLASS
        .toList();
    timeModels.sort((left, right) => left.code.compareTo(right.code));
    final newApplicationMaxY = () {
      var maxY = 0.0;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00200")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (maxY < values.last.valueDouble) {
          maxY = values.last.valueDouble;
        }
      }
      return maxY;
    }();

    final newApplicationMinY = () {
      var minY = double.infinity;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00200")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (minY > values.first.valueDouble) {
          minY = values.first.valueDouble;
        }
      }
      return minY * 0.96;
    }();
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          margin: 0,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            return timeModels[value.toInt()].name.characters.join("\n");
          },
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          getTitles: (value) {
            final interval = newApplicationMaxY - newApplicationMinY;
            if (value.toInt() == newApplicationMinY.toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() == (newApplicationMaxY - 1).toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() ==
                ((interval / 2) + newApplicationMinY).toInt()) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
          showTitles: true,
          margin: 0,
          interval: 1,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
            isCurved: true,
            curveSmoothness: 0,
            colors: const [Color(0xff4af699)],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: timeModels.map((e) {
              final value = rootModel
                  .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
                  .where((element) =>
                      element.time == e.code && element.cat02 == "00200");
              return FlSpot(
                  timeModels.indexOf(e).toDouble(), value.first.valueDouble);
            }).toList()),
      ],
      minX: 0,
      maxX: timeModels.length.toDouble() - 1,
      maxY: newApplicationMaxY,
      minY: newApplicationMinY,
    );
  }

  LineChartData waitingApplicationData(ImmigrationStatisticsRoot rootModel) {
    final timeModels = rootModel
        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "time")
        .CLASS
        .toList();
    timeModels.sort((left, right) => left.code.compareTo(right.code));
    final newApplicationMaxY = () {
      var maxY = 0.0;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00300")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (maxY < values.last.valueDouble) {
          maxY = values.last.valueDouble;
        }
      }
      return maxY;
    }();

    final newApplicationMinY = () {
      var minY = double.infinity;
      for (var timeModel in timeModels) {
        final values = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
            .where((element) =>
                element.time == timeModel.code && element.cat02 == "00300")
            .toList();
        values.sort(
            (left, right) => left.valueDouble.compareTo(right.valueDouble));
        if (minY > values.first.valueDouble) {
          minY = values.first.valueDouble;
        }
      }
      return minY * 0.96;
    }();
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          margin: 0,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          getTitles: (value) {
            return timeModels[value.toInt()].name.characters.join("\n");
          },
        ),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: SideTitles(
          getTitles: (value) {
            final interval = newApplicationMaxY - newApplicationMinY;
            if (value.toInt() == newApplicationMinY.toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() == (newApplicationMaxY - 1).toInt()) {
              return value.toInt().toString();
            } else if (value.toInt() ==
                ((interval / 2) + newApplicationMinY).toInt()) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
          showTitles: true,
          margin: 0,
          interval: 1,
          reservedSize: 40,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
            isCurved: true,
            curveSmoothness: 0,
            colors: const [Color(0xff4af699)],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: timeModels.map((e) {
              final value = rootModel
                  .GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
                  .where((element) =>
                      element.time == e.code && element.cat02 == "00300");
              return FlSpot(
                  timeModels.indexOf(e).toDouble(), value.first.valueDouble);
            }).toList()),
      ],
      minX: 0,
      maxX: timeModels.length.toDouble() - 1,
      maxY: newApplicationMaxY,
      minY: newApplicationMinY,
    );
  }
}
