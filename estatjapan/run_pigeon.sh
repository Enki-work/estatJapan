flutter pub run pigeon \
  --input lib/pigeons/scheme.dart \
  --dart_out lib/pigeons/pigeon.dart \
  --objc_header_out ios/Runner/pigeon.h \
  --objc_source_out ios/Runner/pigeon.m \
  --objc_prefix EJ \
  --java_out ./android/app/src/main/java/Pigeon.java \
  --java_package "com.estatjapan"
