import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:flutter/material.dart';

class MonthSelectPage extends StatelessWidget {
  final RouteModel routeModel;

  const MonthSelectPage({Key? key, required this.routeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClassOBJ? obj = routeModel
        .rootModel?.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "time");
    if (obj == null) return Center(child: Text("予想外エラー"));
    print("{ $obj }");
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(obj.name),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: ListView.separated(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            itemCount: obj.CLASS.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text(obj.CLASS[index].name),
              minVerticalPadding: 25,
            ),
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 0.5,
              indent: 20,
              color: Colors.grey[120],
            ),
          ))
        ]));
  }
}
