import 'package:dio/dio.dart';

class DioHolder {
  late Dio dio;
  final _baseUrl = '';

  /// コンストラクタ
  dioHolder() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    // dio.interceptors.add(PrettyLogInterceptor());
    // dio.interceptors.add(ApiErrorInterceptor());
    // dio.interceptors.add(CacheInterceptor(_apiCacheManager));
    // dio.interceptors.add(FirebasePerformanceInterceptor());
    // dio.transformer = PerformanceTransformer();
    // // UAは全リクエスト共通で付加する
    // dio.options.headers["User-Agent"] = await userAgent();
  }
}
