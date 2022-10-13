import 'package:estatjapan/model/GraphData.dart';
import 'package:estatjapan/util/RouteFacade.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/jsonModel/Class.dart';
import '../model/jsonModel/ClassOBJ.dart';
import '../model/state/RepositoryDataState.dart';
import 'BureauSelectPage.dart';
import 'GraphDataPage.dart';
import 'LineGraphDataPage.dart';
import 'MonthSelectPage.dart';
import 'VisaTypeSelectPage.dart';

class GraphDataSelectPage extends StatelessWidget {
  const GraphDataSelectPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final immigrationStatisticsRoot =
        context.read<RepositoryDataState>().immigrationStatisticsRoot!;
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    ClassOBJ obj = immigrationStatisticsRoot
                        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((e) => e.id == "cat02");
                    final result = await RouteFacade.push<Class?>(
                        context,
                        VisaTypeSelectPage(
                          obj: obj,
                        ));
                    context.read<GraphData>().selectedCat02Mode = result;
                  },
                  child: Text(
                      context.watch<GraphData>().selectedCat02Mode == null
                          ? '在留資格選択'
                          : '在留資格選択\n(${context.watch<GraphData>().selectedCat02Mode?.name})',
                      textAlign: TextAlign.center),
                )),
          ),
          SizedBox(
            height: 110,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {
                    ClassOBJ? obj = immigrationStatisticsRoot
                        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((e) => e.id == "time");

                    final result = await RouteFacade.push<Class?>(
                      context,
                      MonthSelectPage(
                        monthClassObj: obj,
                        pageType: MonthSelectPageType.graph,
                      ),
                    );
                    context.read<GraphData>().selectedMonth = result;
                  },
                  child: Text(
                      context.watch<GraphData>().selectedMonth == null
                          ? '時間軸（月次）選択'
                          : '時間軸（月次）選択\n(${context.watch<GraphData>().selectedMonth?.name})',
                      textAlign: TextAlign.center),
                )),
          ),
          SizedBox(
            height: 110,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {
                    ClassOBJ obj = immigrationStatisticsRoot
                        .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((e) => e.id == "cat03");

                    final result = await RouteFacade.push<Class?>(
                      context,
                      BureauSelectPage(
                        obj: obj,
                      ),
                    );

                    context.read<GraphData>().selectedCat03Mode = result;
                  },
                  child: Text(
                      context.watch<GraphData>().selectedCat03Mode == null
                          ? '地方出入国在留管理局・支局'
                          : '地方出入国在留管理局・支局\n(${context.watch<GraphData>().selectedCat03Mode?.name})',
                      textAlign: TextAlign.center),
                )),
          ),
          SizedBox(
              height: 110,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.5, 60))),
                    icon: const Icon(Icons.pie_chart_rounded),
                    label: const Text("月次円グラフ表示"),
                    onPressed: (context.watch<GraphData>().isModelExist())
                        ? () => RouteFacade.push<Class?>(
                              context,
                              GraphDataPage(
                                graphData: context.read<GraphData>(),
                              ),
                            )
                        : null,
                  ))),
          SizedBox(
              height: 95,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.5, 60))),
                    icon: const Icon(Icons.auto_graph_rounded),
                    label: const Text("全期間折れ線グラフ表示"),
                    onPressed: (context.watch<GraphData>().isModelExist())
                        ? () => RouteFacade.push<Class?>(
                              context,
                              LineGraphDataPage(
                                graphData: context.read<GraphData>(),
                              ),
                            )
                        : null,
                  )))
        ],
      )))
    ]);
  }
}
