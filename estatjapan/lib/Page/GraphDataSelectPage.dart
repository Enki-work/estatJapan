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
  @override
  Widget build(BuildContext context) {
    ImmigrationStatisticsModel isModel =
        Provider.of<ImmigrationStatisticsModel>(context);
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: ListView(
        children: [
          SizedBox(
            height: 110,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {
                    var result = await showModalBottomSheet<Class>(
                      context: context,
                      builder: (BuildContext context) {
                        ClassOBJ obj = isModel.model!.GET_STATS_DATA
                            .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                            .firstWhere((e) => e.id == "cat01");
                        return SafeArea(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: obj.CLASS
                              .map(
                                (e) => SizedBox(
                                    height: 65,
                                    child: ListTile(
                                      title: Text(e.name),
                                      onTap: () {
                                        e.parentID = obj.id;
                                        return Navigator.of(context).pop(e);
                                      },
                                    )),
                              )
                              .toList(),
                        ));
                      },
                    );
                    _selectedCat01Mode = result;
                  },
                  child: const Text('在留資格選択'),
                )),
          ),
          SizedBox(
            height: 110,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {
                    var result = await showModalBottomSheet<Class>(
                      context: context,
                      builder: (BuildContext context) {
                        ClassOBJ? obj = isModel.model!.GET_STATS_DATA
                            .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                            .firstWhere((e) => e.id == "time");
                        return SafeArea(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: obj.CLASS
                              .map(
                                (e) => SizedBox(
                                    height: 65,
                                    child: ListTile(
                                      title: Text(e.name),
                                      onTap: () {
                                        e.parentID = obj.id;
                                        return Navigator.of(context).pop(e);
                                      },
                                    )),
                              )
                              .toList(),
                        ));
                      },
                    );
                    _selectedCat01Mode = result;
                  },
                  child: const Text('時間軸選択'),
                )),
          ),
          SizedBox(
            height: 110,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('在留管理局・支局選択'),
                )),
          )
        ],
      ))
    ]);
  }
}
