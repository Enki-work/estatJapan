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
            future: _dio.get(widget.graphData.url),
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
    final models = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((element) => element.id == "cat02")
        .CLASS
        .where((element) => element.level == "1")
        .toList();
    final totalResult = rootModel.GET_STATS_DATA.STATISTICAL_DATA.DATA_INF.VALUE
        .firstWhere((element) => element.cat02 == models.first.code);

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
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: 250,
                child: _LineChart(),
              )
            ],
          );
        })));
  }
}

class _LineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: true,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: true),
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
              case 4:
                return '5m';
              case 5:
                return '6m';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        // lineChartBarData2_2,
        // lineChartBarData2_3,
      ];

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 50,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 2:
              return 'SEPT';
            case 7:
              return 'OCT';
            case 12:
              return 'DEC';
          }
          return '';
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [Color(0xff4af699)],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 4),
          FlSpot(5, 1.8),
          FlSpot(7, 5),
          FlSpot(10, 2),
          FlSpot(12, 2.2),
          FlSpot(13, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        colors: const [Color(0xffaa4cfc)],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          colors: [
            const Color(0x33aa4cfc),
          ],
        ),
        spots: [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        colors: const [Color(0xff27b6fc)],
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}
