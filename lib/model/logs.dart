import 'package:meta/meta.dart';
import 'dart:convert';

class Log {
  Log({
    required this.name,
    required this.value,
  });

  String name;
  String value;

  factory Log.fromRawJson(String str) => Log.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}
