import 'dart:convert';

class WeatherPrediction {
  WeatherPrediction({
    required this.today,
    required this.yesterday,
    required this.tomorrow,
  });

  Weather today;
  Weather yesterday;
  Weather tomorrow;

  factory WeatherPrediction.fromRawJson(String str) =>
      WeatherPrediction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherPrediction.fromJson(Map<String, dynamic> json) =>
      WeatherPrediction(
        today: Weather.fromJson(json["today"]),
        yesterday: Weather.fromJson(json["yesterday"]),
        tomorrow: Weather.fromJson(json["tomorrow"]),
      );

  Map<String, dynamic> toJson() => {
        "today": today.toJson(),
        "yesterday": yesterday.toJson(),
        "tomorrow": tomorrow.toJson(),
      };
}

class Weather {
  Weather({
    required this.min,
    required this.max,
    required this.current,
    required this.status,
    required this.uv,
    required this.humidity,
    required this.rainChance,
  });

  int min;
  int max;
  int? current;
  String? status;
  String? uv;
  int? humidity;
  int rainChance;

  factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        min: json["min"],
        max: json["max"],
        current: json["current"] == null ? null : json["current"],
        status: json["status"] == null ? null : json["status"],
        uv: json["uv"] == null ? null : json["uv"],
        humidity: json["humidity"] == null ? null : json["humidity"],
        rainChance: json["rain_chance"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
        "current": current == null ? null : current,
        "status": status == null ? null : status,
        "uv": uv == null ? null : uv,
        "humidity": humidity == null ? null : humidity,
        "rain_chance": rainChance,
      };
}
