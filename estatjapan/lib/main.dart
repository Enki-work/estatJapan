import 'dart:async';

import 'package:estatjapan/util/AppInitializer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  runZonedGuarded(() async {
    AppInitializer().run();
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
