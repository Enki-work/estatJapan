import 'package:flutter_package/model/Class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ClassOBJ.g.dart';

@JsonSerializable()
class ClassOBJ {
  @JsonKey(name: "@id")
  final String id;
  @JsonKey(name: "@name")
  final String name;

  @JsonKey(name: "CLASS", fromJson: _getOptionalClass)
  final List<Class> CLASS;

  ClassOBJ({required this.id, required this.name, required this.CLASS});
  factory ClassOBJ.fromJson(Map<String, dynamic> json) =>
      _$ClassOBJFromJson(json);
  Map<String, dynamic> toJson() => _$ClassOBJToJson(this);

  static List<Class> _getOptionalClass(dynamic CLASS) {
    List<Class> ClassList = [];
    if (CLASS is List<dynamic>) {
      List<dynamic> list = CLASS;
      list.forEach((element) {
        ClassList.add(Class.fromJson(element));
      });
    } else if (CLASS is Map<String, dynamic>) {
      ClassList.add(Class.fromJson(CLASS));
    }
    return ClassList;
  }
}
