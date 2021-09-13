import 'package:dio/dio.dart';
import 'package:estatjapan/Util/AppConfig.dart';
import 'package:estatjapan/model/BannerAdModel.dart';
import 'package:estatjapan/model/ClassOBJ.dart';
import 'package:estatjapan/model/ImmigrationStatisticsRoot.dart';
import 'package:estatjapan/model/RouteModel.dart';
import 'package:estatjapan/model/Value.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:horizontal_data_table/scroll/scroll_bar_style.dart';
import 'package:provider/provider.dart';

class DataTablePage extends StatefulWidget {
  static const double height = 56;
  static const double width = 110;
  static const double compactWidth = 70;

  final RouteModel routeModel;

  const DataTablePage({Key? key, required this.routeModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  @override
  Widget build(BuildContext context) {
    Dio _dio = Dio();
    String url =
        "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?cdTab=160&appId=${AppConfig.shared.estatAppId}&lang=J&statsDataId=0003423913&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0";
    if (widget.routeModel.selectedMonth != null) {
      url = url + "&cdTime=" + widget.routeModel.selectedMonth!.code;
    }
    final idStr = widget.routeModel.selectedCLASS.parentID;
    if (idStr != null && idStr.isNotEmpty) {
      url = url +
          "&cd" +
          idStr.replaceFirst(idStr[0], idStr[0].toUpperCase()) +
          "=" +
          widget.routeModel.selectedCLASS.code;
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
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Widget _getBodyWidget() {
    final leftHandSideColumnWidth =
        widget.routeModel.selectedCLASS.parentID == "cat02"
            ? DataTablePage.compactWidth * 2
            : DataTablePage.width;
    final rightHandSideColumnWidth =
        widget.routeModel.selectedCLASS.parentID == "cat03"
            ? MediaQuery.of(context).size.width - leftHandSideColumnWidth
            : widget.routeModel.rootModel!.GET_STATS_DATA.STATISTICAL_DATA
                    .CLASS_INF.CLASS_OBJ
                    .firstWhere((element) => element.id == "cat03")
                    .CLASS
                    .length *
                DataTablePage.width;
    return ChangeNotifierProvider<BannerAdModel>(
        create: (_) => BannerAdModel()..loadBannerAd(),
        child: OrientationBuilder(builder: (context, orientation) {
          BannerAdModel bAdModel = Provider.of<BannerAdModel>(context);
          return Column(children: [
            if (orientation == Orientation.portrait) Container(
              child: AdWidget(ad: bAdModel.bannerAd()),
              width: bAdModel.bannerAd().size.width.toDouble(),
              height: 72.0,
              alignment: Alignment.center,
            ),
            Expanded(
              child: HorizontalDataTable(
                leftHandSideColumnWidth: leftHandSideColumnWidth,
                rightHandSideColumnWidth: rightHandSideColumnWidth,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: () {
                  if (widget.routeModel.selectedCLASS.parentID == "cat01") {
                    return widget.routeModel.rootModel!.GET_STATS_DATA
                        .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((element) => element.id == "cat02")
                        .CLASS
                        .length;
                  } else if (widget.routeModel.selectedCLASS.parentID ==
                      "cat02") {
                    return widget.routeModel.rootModel!.GET_STATS_DATA
                        .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                        .firstWhere((element) => element.id == "cat01")
                        .CLASS
                        .length;
                  } else {
                    return widget.routeModel.rootModel!.GET_STATS_DATA
                            .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                            .firstWhere((element) => element.id == "cat01")
                            .CLASS
                            .length *
                        widget.routeModel.rootModel!.GET_STATS_DATA
                            .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
                            .firstWhere((element) => element.id == "cat02")
                            .CLASS
                            .length;
                  }
                }(),
                rowSeparatorWidget: Divider(
                  color: Colors.grey[120],
                  height: 0.5,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                verticalScrollbarStyle: ScrollbarStyle(
                  thumbColor: Theme.of(context).primaryColorDark,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: const Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: ScrollbarStyle(
                  thumbColor: Theme.of(context).primaryColorDark,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: const Radius.circular(5.0),
                ),
              ),
            )
          ]);
        }));
  }

  List<Widget> _getTitleWidget() {
    if (widget.routeModel.selectedCLASS.parentID == "cat03") {
      return [
        const SizedBox(
          width: DataTablePage.width,
          height: DataTablePage.height,
        ),
        _getTitleItemWidget(
            widget.routeModel.selectedCLASS.name, DataTablePage.width)
      ];
    } else {
      List<Widget> list = List<Widget>.from(widget.routeModel.rootModel!
          .GET_STATS_DATA.STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03")
          .CLASS
          .map((e) => _getTitleItemWidget(e.name, DataTablePage.width))
          .toList());
      list.insert(
          0,
          const SizedBox(
            width: DataTablePage.width,
            height: DataTablePage.height,
          ));
      return list;
    }
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      width: width,
      height: DataTablePage.height,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
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
        width: DataTablePage.width,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    } else if (widget.routeModel.selectedCLASS.parentID == "cat02") {
      ClassOBJ obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      return Container(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  obj.CLASS[index].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                )),
            Expanded(
                flex: 1,
                child: Text(widget.routeModel.selectedCLASS.name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center))
          ],
        ),
        width: DataTablePage.compactWidth * 2,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    } else {
      ClassOBJ cat01Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ cat02Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      int cat01Index = index ~/ cat02Obj.CLASS.length;
      int cat02Index = (index % cat02Obj.CLASS.length).toInt();
      return Container(
        child: Flex(
          direction: Axis.horizontal,
          children: () {
            return [
              Expanded(
                  flex: 1,
                  child: Text(cat01Obj.CLASS[cat01Index].name,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 1,
                  child: Text(cat02Obj.CLASS[cat02Index].name,
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center))
            ];
          }(),
        ),
        width: DataTablePage.compactWidth * 2,
        height: DataTablePage.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.center,
      );
    }
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
      for (var element in objCat03.CLASS) {
        for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
            .STATISTICAL_DATA.DATA_INF.VALUE) {
          if (value.cat01 == widget.routeModel.selectedCLASS.code &&
              value.cat02 == cat02Code &&
              value.cat03 == element.code) {
            children.add(Container(
              child: Text(value.value ?? ""),
              width: DataTablePage.width,
              height: DataTablePage.height,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ));
            break;
          }
        }
      }
      return Row(children: children);
    } else if (widget.routeModel.selectedCLASS.parentID == "cat02") {
      ClassOBJ objCat01 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ objCat03 = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat03");
      String cat01Code = objCat01.CLASS[index].code;
      List<Widget> children = [];
      for (var element in objCat03.CLASS) {
        for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
            .STATISTICAL_DATA.DATA_INF.VALUE) {
          if (value.cat01 == cat01Code &&
              value.cat02 == widget.routeModel.selectedCLASS.code &&
              value.cat03 == element.code) {
            children.add(Container(
              child: Text(value.value ?? ""),
              width: DataTablePage.width,
              height: DataTablePage.height,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
            ));
            break;
          }
        }
      }
      return Row(children: children);
    } else {
      ClassOBJ cat01Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat01");
      ClassOBJ cat02Obj = widget.routeModel.rootModel!.GET_STATS_DATA
          .STATISTICAL_DATA.CLASS_INF.CLASS_OBJ
          .firstWhere((element) => element.id == "cat02");
      int cat01Index = index ~/ cat02Obj.CLASS.length;
      int cat02Index = (index % cat02Obj.CLASS.length).toInt();
      List<Widget> children = [];

      for (Value value in widget.routeModel.loadedDatarootModel.GET_STATS_DATA
          .STATISTICAL_DATA.DATA_INF.VALUE) {
        if (value.cat01 == cat01Obj.CLASS[cat01Index].code &&
            value.cat02 == cat02Obj.CLASS[cat02Index].code &&
            value.cat03 == widget.routeModel.selectedCLASS.code) {
          children.add(Container(
            child: Text(value.value ?? ""),
            width: DataTablePage.width,
            height: DataTablePage.height,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
          ));
          break;
        }
      }
      return Row(
        children: children,
      );
    }
  }
}
