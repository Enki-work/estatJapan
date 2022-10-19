import 'package:freezed_annotation/freezed_annotation.dart';

part 'OSSPackageInfo.freezed.dart';

@freezed
class OSSPackageInfo with _$OSSPackageInfo {
  const OSSPackageInfo._();
  const factory OSSPackageInfo({
    /// Package name
    @Default("") String name,

    /// Description
    @Default("") String description,

    /// Website URL
    String? homepage,

    /// Repository URL
    String? repository,

    /// Authors
    @Default([]) List<String> authors,

    /// Version
    @Default("") String version,

    /// License
    String? license,

    /// Whether the license is in markdown format or not (plain text).
    @Default(false) bool isMarkdown,

    /// Whether the package is included in the SDK or not.
    @Default(false) bool isSdk,

    /// Whether the package is direct dependency or not.
    @Default(false) bool isDirectDependency,
    @Default(false) bool isExpanded,
  }) = _OSSPackageInfo;
}
