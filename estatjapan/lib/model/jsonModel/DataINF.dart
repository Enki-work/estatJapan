import 'package:json_annotation/json_annotation.dart';

import 'Class.dart';
import 'Value.dart';

part 'DataINF.g.dart';

@JsonSerializable()
class DataINF {
  final List<Value> VALUE;
  DataINF({required this.VALUE});
  factory DataINF.fromJson(Map<String, dynamic> json) =>
      _$DataINFFromJson(json);
  Map<String, dynamic> toJson() => _$DataINFToJson(this);

  List<Value> valueByCheckCat01(List<Class> cat01Level01) {
    final notDoneCode =
        cat01Level01.firstWhere((element) => element.name == "未済").code;
    final doneCode =
        cat01Level01.firstWhere((element) => element.name == "既済_総数").code;
    final totalCode =
        cat01Level01.firstWhere((element) => element.name == "受理_総数").code;
    var notDoneValues = List<Value>.empty(growable: true);
    final monthCodeList = VALUE.map((e) => e.time).toSet();

    final cat02CodeList = VALUE.map((e) => e.cat02).toSet();

    final cat03CodeList = VALUE.map((e) => e.cat03).toSet();

    for (var monthCode in monthCodeList) {
      for (var cat02Code in cat02CodeList) {
        for (var cat03Code in cat03CodeList) {
          final values = VALUE.where((element) {
            final result = element.time == monthCode &&
                element.cat02 == cat02Code &&
                element.cat03 == cat03Code;
            return result;
          });

          if (values
              .where((element) => element.cat01 == notDoneCode)
              .isNotEmpty) {
            continue;
          }
          final notDoneValue = (int.parse(values
                          .firstWhere((element) => element.cat01 == totalCode)
                          .value ??
                      '') -
                  int.parse(values
                          .firstWhere((element) => element.cat01 == doneCode)
                          .value ??
                      ''))
              .toString();
          notDoneValues.add(Value(
              tab: values.first.tab,
              cat01: notDoneCode,
              cat02: cat02Code,
              cat03: cat03Code,
              time: monthCode,
              unit: values.first.unit,
              value: notDoneValue));
        }
      }
    }
    return VALUE + notDoneValues;
  }
}
