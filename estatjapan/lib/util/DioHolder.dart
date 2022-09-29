import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

class DioHolder {
  late Dio dio;
  final _baseUrl = '';

  /// コンストラクタ
  DioHolder() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    dio.interceptors.add(_DioInterceptor());
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
    String responseErrorLog = "${res.toString()}";

    return responseLog + dioErrorLog + responseErrorLog;
  }
}
