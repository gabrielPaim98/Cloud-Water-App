import 'dart:convert';

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
