import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../firebase_options.dart';
import '../util/DioHolder.dart';
import 'Application.dart';

///
/// アプリの初期化を管理する
///
class AppInitializer {
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();
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
    runZonedGuarded<Future<void>>(() async {
      initialize().then((app) {
        runApp(
          GetMaterialApp(
            home: ProviderScope(
              child: app,
            ),
          ),
        );
      });
    },
        (error, stack) => FirebaseCrashlytics.instance
            .recordError(error, stack, fatal: true));
  }

  /// アプリ実行に必要なセットアップを入れる
  Future<Widget> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb) {
      // Crashlytics 設定

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      await AppInitializer.firebaseAnalytics.logBeginCheckout();
    }
    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      if (kDebugMode) {
        print(fcmToken);
      }
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
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
  }

  /// リリースビルドのセットアップ
  void setUpRelease() {}

  /// デバッグビルドのセットアップ
  void setUpDebug() {
    // FirebasePerformance.instance.setPerformanceCollectionEnabled(false);
  }
}
