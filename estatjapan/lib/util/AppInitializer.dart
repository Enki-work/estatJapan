import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/DioHolder.dart';
import 'Application.dart';

///
/// アプリの初期化を管理する
///
class AppInitializer {
  bool isRestart = false;

  /// コンストラクタ
  AppInitializer();

  ///
  /// 再起動用のコンストラクタ
  /// refreshTokenによる更新が失敗したときや、ログアウトなどで使う
  ///
  AppInitializer.restart() {
    isRestart = true;
  }

  /// アプリのスタート
  void run() {
    WidgetsFlutterBinding.ensureInitialized();

    initialize().then((app) {
      runApp(ProviderScope(
        child: app,
      ));
    });
  }

  /// アプリ実行に必要なセットアップを入れる
  Future<Widget> initialize() async {
    try {
      // Crashlytics 設定
      // await Firebase.initializeApp();
      // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = (details) {
        // dump to Console
        FlutterError.dumpErrorToConsole(details);

        // Crashlytics
        // FirebaseCrashlytics.instance.recordFlutterError(details);
      };

      if (kReleaseMode) {
        setUpRelease();
      } else {
        setUpDebug();
      }

      final holder = DioHolder();

      return Application(
        key: UniqueKey(),
        isRestart: isRestart,
        dioHolder: holder,
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  /// リリースビルドのセットアップ
  void setUpRelease() {}

  /// デバッグビルドのセットアップ
  void setUpDebug() {
    // FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
  }
}
