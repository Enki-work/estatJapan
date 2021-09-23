import 'package:dio/dio.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
            }));
  }

  Widget _lineChart(ImmigrationStatisticsRoot rootModel) {
    return ChangeNotifierProvider<BannerAdModel>(
        create: (_) => BannerAdModel()..loadBannerAd(),
        child: SafeArea(child: Builder(builder: (context) {
          BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Container(
                child: AdWidget(ad: bAdModel.bannerAd()),
                width: bAdModel.bannerAd().size.width.toDouble(),
                height: 72.0,
                alignment: Alignment.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  "${widget.graphData.selectedCat01Mode!.name}許可率",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 250,
                child: LineChart(
                  passRateData(rootModel),
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
}
