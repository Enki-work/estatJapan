import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/BannerAdModel.dart';
import '../model/RouteModel.dart';
import '../model/jsonModel/Class.dart';
import '../model/jsonModel/ClassOBJ.dart';
import '../model/jsonModel/ImmigrationStatisticsRoot.dart';
import '../model/state/RootPageState.dart';

class ImmigrationStatisticsTypeSelectPage extends StatelessWidget {
  const ImmigrationStatisticsTypeSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _cat01ListView(
            context.watch<RootPageState>().immigrationStatisticsRoot!,
            context.watch<BannerAdModel>())
      ],
    );
  }

  Widget _cat01ListView(
      ImmigrationStatisticsRoot rootModel, BannerAdModel bAdModel) {
    ClassOBJ obj = rootModel.GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
        .firstWhere((e) => e.id == "cat01");
    return Expanded(
        child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      itemCount: obj.CLASS.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Class CLASS = obj.CLASS[index];
        return ListTile(
          title: Text(CLASS.name),
          minVerticalPadding: 25,
          onTap: () {
            CLASS.parentID = obj.id;
            Navigator.of(context).pushNamed("MonthSelectPage",
                arguments:
                    RouteModel(rootModel: rootModel, selectedCLASS: CLASS));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 0.5,
        indent: 20,
        color: Colors.grey[120],
      ),
    ));
  }
}
