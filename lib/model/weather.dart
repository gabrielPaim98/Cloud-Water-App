import 'dart:convert';

class WeatherPrediction {
  WeatherPrediction({
    required this.today,
    required this.tomorrow,
  });

  Weather today;
  Weather tomorrow;

  factory WeatherPrediction.fromRawJson(String str) =>
      WeatherPrediction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherPrediction.fromJson(Map<String, dynamic> json) =>
      WeatherPrediction(
        today: Weather.fromJson(json["today"]),
        tomorrow: Weather.fromJson(json["tomorrow"]),
      );

  Map<String, dynamic> toJson() => {
        "today": today.toJson(),
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

  double min;
  double max;
  double? current;
  String? status;
  String? uv;
  double? humidity;
  double rainChance;

  factory Weather.fromRawJson(String str) => Weather.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        min: double.parse(json["min"].toString()),
        max: double.parse(json["max"].toString()),
        current: json["current"] == null ? null : double.parse(json["current"].toString()),
        status: json["status"] == null ? null : json["status"],
        uv: json["uv"] == null ? null : json["uv"],
        humidity: json["humidity"] == null ? null : double.parse(json["humidity"].toString()),
        rainChance: json["rain_chance"] == null ? 0.0 : double.parse(json["rain_chance"].toString()),
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
