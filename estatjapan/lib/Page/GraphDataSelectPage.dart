import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/model/ImmigrationStatisticsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphDataSelectPage extends StatelessWidget {
  const GraphDataSelectPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ImmigrationStatisticsModel isModel =
        Provider.of<ImmigrationStatisticsModel>(context);
    return ChangeNotifierProvider(
        create: (_) => GraphData(),
        child: Builder(
            builder: (context) =>
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                      child: SafeArea(
                          child: ListView(
                    children: [
                      SizedBox(
                        height: 110,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () async {
                                ClassOBJ obj = isModel.model!.GET_STATS_DATA
                                    .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                                    .firstWhere((e) => e.id == "cat01");
                                final result = await Navigator.of(context)
                                    .pushNamed("VisaTypeSelectPage",
                                        arguments: obj) as Class?;
                                Provider.of<GraphData>(context, listen: false)
                                    .selectedCat01Mode = result;
                              },
                              child: Text(
                                  Provider.of<GraphData>(context, listen: true)
                                              .selectedCat01Mode ==
                                          null
                                      ? '在留資格選択'
                                      : '在留資格選択\n(${Provider.of<GraphData>(context, listen: true).selectedCat01Mode?.name})',
                                  textAlign: TextAlign.center),
                            )),
                      ),
                      SizedBox(
                        height: 110,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () async {
                                ClassOBJ? obj = isModel.model!.GET_STATS_DATA
                                    .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                                    .firstWhere((e) => e.id == "time");
                                final result = await Navigator.of(context)
                                    .pushNamed("MonthSelectPage",
                                        arguments: obj) as Class?;
                                Provider.of<GraphData>(context, listen: false)
                                    .selectedMonth = result;
                              },
                              child: Text(
                                  Provider.of<GraphData>(context, listen: true)
                                              .selectedMonth ==
                                          null
                                      ? '時間軸（月次）選択'
                                      : '時間軸（月次）選択\n(${Provider.of<GraphData>(context, listen: true).selectedMonth?.name})',
                                  textAlign: TextAlign.center),
                            )),
                      ),
                      SizedBox(
                        height: 110,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: OutlinedButton(
                              onPressed: () async {
                                ClassOBJ obj = isModel.model!.GET_STATS_DATA
                                    .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                                    .firstWhere((e) => e.id == "cat03");
                                final result = await Navigator.of(context)
                                    .pushNamed("BureauSelectPage",
                                        arguments: obj) as Class?;
                                Provider.of<GraphData>(context, listen: false)
                                    .selectedCat03Mode = result;
                              },
                              child: Text(
                                  Provider.of<GraphData>(context, listen: true)
                                              .selectedCat03Mode ==
                                          null
                                      ? '地方出入国在留管理局・支局'
                                      : '地方出入国在留管理局・支局\n(${Provider.of<GraphData>(context, listen: true).selectedCat03Mode?.name})',
                                  textAlign: TextAlign.center),
                            )),
                      ),
                      SizedBox(
                          height: 110,
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(Size(
                                        MediaQuery.of(context).size.width * 0.5,
                                        60))),
                                icon: const Icon(Icons.pie_chart_rounded),
                                label: const Text("月次円グラフ表示"),
                                onPressed: (Provider.of<GraphData>(context,
                                            listen: true)
                                        .isModelExist())
                                    ? () {
                                        Navigator.of(context).pushNamed(
                                            "GraphDataPage",
                                            arguments: Provider.of<GraphData>(
                                                context,
                                                listen: false));
                                      }
                                    : null,
                              ))),
                      SizedBox(
                          height: 95,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(Size(
                                        MediaQuery.of(context).size.width * 0.5,
                                        60))),
                                icon: const Icon(Icons.auto_graph_rounded),
                                label: const Text("全期間折れ線グラフ表示"),
                                onPressed: (Provider.of<GraphData>(context,
                                            listen: true)
                                        .isModelExist())
                                    ? () {
                                        Navigator.of(context).pushNamed(
                                            "LineGraphDataPage",
                                            arguments: Provider.of<GraphData>(
                                                context,
                                                listen: false));
                                      }
                                    : null,
                              )))
                    ],
                  )))
                ])));
  }
}
