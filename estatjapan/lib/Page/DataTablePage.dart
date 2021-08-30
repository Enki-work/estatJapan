import 'package:dio/dio.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:estatjapan/model/Value.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/waterdrop_header.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';

class DataTablePage extends StatefulWidget {
  final RouteModel routeModel;

  const DataTablePage({Key? key, required this.routeModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    String url =
        "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?cdTab=160&appId=7bed85b352e6c3d46ad6def4390196b23d86bcec&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0";
    if (widget.routeModel.selectedMonth != null) {
      url = url + "&cdTime=" + widget.routeModel.selectedMonth!.code;
    }
    if (widget.routeModel.selectedCLASS != null) {
      final idStr = widget.routeModel.selectedCLASS.parentID;
      if (idStr != null && idStr.isNotEmpty) {
        url = url +
            "&cd" +
            idStr.replaceFirst(idStr[0], idStr[0].toUpperCase()) +
            "=" +
            widget.routeModel.selectedCLASS.code;
      }
    }
    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text(widget.routeModel.selectedCLASS.name +
              "（" +
              (widget.routeModel.selectedMonth?.name ?? "") +
              "）"),
        ),
        body: FutureBuilder(
            future: _dio.get(url),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                Response response = snapshot.data;
                ImmigrationStatisticsRoot rootModel =
                    ImmigrationStatisticsRoot.fromJson(response.data);
                widget.routeModel.loadedDatarootModel = rootModel;
                return _getBodyWidget();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _getBodyWidget() {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 110,
        rightHandSideColumnWidth: widget.routeModel.rootModel!.GET_STATS_DATA
                .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                .firstWhere((element) => element.id == "cat03")
                .CLASS
                .length *
            110,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: widget.routeModel.rootModel!.GET_STATS_DATA.STATISTICAL_DATA
            .CLASS_INF.CLASS_OBJ
            .firstWhere((element) => element.id == "cat02")
            .CLASS
            .length,
        rowSeparatorWidget: Divider(
          color: Colors.grey[120],
          height: 0.5,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.yellow,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.red,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 60,
        onRefresh: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.refreshCompleted();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    if (widget.routeModel.selectedCLASS.parentID == "cat01") {
      List<Widget> list = List<Widget>.from(widget.routeModel.rootModel!
          .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03")
          .CLASS
          .map((e) => _getTitleItemWidget(e.name, 110))
          .toList());
      list.insert(
          0,
          SizedBox(
            width: 110,
            height: 56,
          ));
      return list;
    }
    return [];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    if (widget.routeModel.selectedCLASS.parentID == "cat01") {
      ClassOBJ obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      return Container(
        child: Text(obj.CLASS[index].name),
        width: 110,
        height: 52,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }
    return Row(
      children: [],
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    if (widget.routeModel.selectedCLASS.parentID == "cat01") {
      ClassOBJ objCat02 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      ClassOBJ objCat03 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03");
      String cat02Code = objCat02.CLASS[index].code;
      List<Widget> children = [];
      objCat03.CLASS.forEach((element) {
        for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
            .STATISTICAL_DATA.DATA_INF.VALUE) {
          if (value.cat01 == widget.routeModel.selectedCLASS.code &&
              value.cat02 == cat02Code &&
              value.cat03 == element.code) {
            children.add(Container(
              child: Text(value.value ?? ""),
              width: 110,
              height: 52,
              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ));
          }
        }
      });
      return Row(children: children);
    }
    return Row(
      children: [],
    );
  }
}
