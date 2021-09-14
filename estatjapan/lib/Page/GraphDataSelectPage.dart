import 'package:estatjapan/model/Class.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/ImmigrationStatisticsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphDataSelectPage extends StatefulWidget {
  const GraphDataSelectPage({Key? key}) : super(key: key);
  @override
  _GraphDataSelectPageState createState() => _GraphDataSelectPageState();
}

class _GraphDataSelectPageState extends State<GraphDataSelectPage> {
  Class? _selectedCat01Mode;
  Class? _selectedCat02Mode;
  Class? _selectedCat03Mode;

  @override
  Widget build(BuildContext context) {
    ImmigrationStatisticsModel isModel =
        Provider.of<ImmigrationStatisticsModel>(context);
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
                    ClassOBJ obj = isModel.model!.GET_STATS_DATA
                        .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((e) => e.id == "cat01");
                    final result = await Navigator.of(context)
                            .pushNamed("VisaTypeSelectPage", arguments: obj)
                        as Class?;
                    setState(() {
                      _selectedCat01Mode = result;
                    });
                  },
                  child: Text(
                      _selectedCat01Mode == null
                          ? '在留資格選択'
                          : '在留資格選択\n(${_selectedCat01Mode?.name})',
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
                        .pushNamed("MonthSelectPage", arguments: obj) as Class?;
                    setState(() {
                      _selectedCat02Mode = result;
                    });
                  },
                  child: Text(
                      _selectedCat02Mode == null
                          ? '時間軸（月次）選択'
                          : '時間軸（月次）選択\n(${_selectedCat02Mode?.name})',
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
                            .pushNamed("BureauSelectPage", arguments: obj)
                        as Class?;
                    setState(() {
                      _selectedCat03Mode = result;
                    });
                  },
                  child: Text(
                      _selectedCat03Mode == null
                          ? '地方出入国在留管理局・支局'
                          : '地方出入国在留管理局・支局\n(${_selectedCat03Mode?.name})',
                      textAlign: TextAlign.center),
                )),
          )
        ],
      )))
    ]);
  }
}
