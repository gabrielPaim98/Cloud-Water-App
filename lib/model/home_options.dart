import 'dart:convert';

import 'package:cloud_water/model/firestore_config.dart';
import 'package:cloud_water/model/firestore_main_iot.dart';
import 'package:cloud_water/model/firestore_user.dart';

class HomeOptions {
  HomeOptions({
    required this.faucetOn,
    required this.soilRead,
    required this.config,
  });

  bool faucetOn;
  List<SoilRead> soilRead;
  List<Config> config;

  factory HomeOptions.fromRawJson(String str) =>
      HomeOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeOptions.fromJson(Map<String, dynamic> json) => HomeOptions(
        faucetOn: json["faucet_on"],
        soilRead: List<SoilRead>.from(
            json["soil_read"].map((x) => SoilRead.fromJson(x))),
        config:
            List<Config>.from(json["config"].map((x) => Config.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "faucet_on": faucetOn,
        "soil_read": List<dynamic>.from(soilRead.map((x) => x.toJson())),
        "config": List<dynamic>.from(config.map((x) => x.toJson())),
      };

  factory HomeOptions.fromFirestore(FirestoreUser user,
      List<FirestoreConfig> firestoreConfig, FirestoreMainIot mainIot) {
    bool faucetOn;
    List<SoilRead> soilRead = [];
    List<Config> config = [];

    faucetOn = user.settings.faucetOn;

    mainIot.lastSoilRead.forEach((e) {
      String stsString = e.status;
      SoilReadStatus soilReadStatus = SoilReadStatus.HIGH;
      if (stsString == 'low') {
        soilReadStatus = SoilReadStatus.LOW;
      } else if (stsString == 'normal') {
        soilReadStatus = SoilReadStatus.NORMAL;
      }
      soilRead
          .add(SoilRead(name: e.name, value: e.value, status: soilReadStatus));
    });

    user.settings.settingsConfig.forEach((e) {
      String name;
      bool value;

      name = firestoreConfig.firstWhere((element) => element.id == e.id).name;
      value = e.isActive;
      config.add(Config(name: name, value: value));
    });

    return HomeOptions(faucetOn: faucetOn, soilRead: soilRead, config: config);
  }
}

class Config {
  Config({
    required this.name,
    required this.value,
  });

  String name;
  bool value;

  factory Config.fromRawJson(String str) => Config.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

enum SoilReadStatus { LOW, NORMAL, HIGH }

class SoilRead {
  SoilRead({
    required this.name,
    required this.value,
    required this.status,
  });

  String name;
  double value;
  SoilReadStatus status;

  factory SoilRead.fromRawJson(String str) =>
      SoilRead.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SoilRead.fromJson(Map<String, dynamic> json) {
    String stsString = json["status"].toString();
    SoilReadStatus soilReadStatus = SoilReadStatus.HIGH;
    if (stsString == 'low') {
      soilReadStatus = SoilReadStatus.LOW;
    } else if (stsString == 'normal') {
      soilReadStatus = SoilReadStatus.NORMAL;
    }

    return SoilRead(
      name: json["name"],
      value: json["value"].toDouble(),
      status: soilReadStatus,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "status": status,
      };
}
