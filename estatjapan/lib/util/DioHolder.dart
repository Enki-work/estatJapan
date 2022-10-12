import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

import '../model/RouteModel.dart';
import '../model/jsonModel/ImmigrationStatisticsRoot.dart';

class DioHolder {
  late Dio dio;
  final _baseUrl = '';

  /// コンストラクタ
  DioHolder() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    dio.interceptors.add(_DioInterceptor());
  }

  Future<ImmigrationStatisticsRoot> getMenuData(String estatAppId) async {
    final res = await dio.get(
        "https://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=$estatAppId&lang=J&statsDataId=0003449073&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0");
    return ImmigrationStatisticsRoot.fromJson(res.data);
  }

  Future<ImmigrationStatisticsRoot> getDataTable(
      String estatAppId, RouteModel routeModel) async {
    String url =
        "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=$estatAppId&lang=J&statsDataId=0003449073&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0";
    if (routeModel.selectedMonth != null) {
      url = url + "&cdTime=" + routeModel.selectedMonth!.code;
    }
    final idStr = routeModel.selectedCLASS.parentID;
    if (idStr != null && idStr.isNotEmpty) {
      url = url +
          "&cd" +
          idStr.replaceFirst(idStr[0], idStr[0].toUpperCase()) +
          "=" +
          routeModel.selectedCLASS.code;
    }
    final res = await dio.get(url);
    return ImmigrationStatisticsRoot.fromJson(res.data);
  }

  Future<ImmigrationStatisticsRoot> getData(String estatAppId,
      {String? selectedCat01,
      String? selectedCat03,
      String? selectedMonth}) async {
    String url =
        "http://api.e-stat.go.jp/rest/3.0/app/json/getStatsData?appId=$estatAppId&lang=J&statsDataId=0003449073&metaGetFlg=Y&cntGetFlg=N&explanationGetFlg=Y&annotationGetFlg=Y&sectionHeaderFlg=1&replaceSpChars=0";
    if (selectedMonth != null) {
      url = url + "&cdTime=" + selectedMonth;
    }
    if (selectedCat01 != null) {
      url = url + "&cdCat01=" + selectedCat01;
    }
    if (selectedCat03 != null) {
      url = url + "&cdCat03=" + selectedCat03;
    }
    final res = await dio.get(url);
    return ImmigrationStatisticsRoot.fromJson(res.data);
  }
}

class _DioInterceptor extends Interceptor {
  @override
  void onError(
      DioError dioError, ErrorInterceptorHandler errorInterceptorHandler) {
    // 400系のバリデーションエラーはレポート必要なし
    final statusCode = dioError.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && 600 > statusCode) {
      Chain chain = Chain.current().terse;
      Error encloser = _ApiError(dioError);

      final logMessage = encloser.toString();
      debugPrint(logMessage);

      // Firebase Crashlyticsへ送信
      FirebaseCrashlytics.instance.recordError(encloser, chain);
    }
    super.onError(dioError, errorInterceptorHandler);
  }
}

class _ApiError extends Error {
  final DioError _error;

  /// コンストラクタ
  _ApiError(this._error);

  @override
  String toString() {
    final res = _error.response;

    String responseLog = "${res?.statusMessage} [${res?.requestOptions.uri}]: ";
    String dioErrorLog = "${_error.toString()}: \n";
    String responseErrorLog = res.toString();

    return responseLog + dioErrorLog + responseErrorLog;
  }
}
