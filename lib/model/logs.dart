import 'dart:convert';

import 'package:cloud_water/model/firestore_main_iot.dart';

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

  static List<Log> fromFirestore(FirestoreMainIot mainIot) {
    List<Log> logs = [];

    mainIot.log.forEach((e) {
      logs.add(Log(name: e.timeStamp, value: e.msg));
    });

    return logs;
  }
}
