import 'dart:convert';

import 'package:cloud_water/model/home_options.dart';
import 'package:cloud_water/model/logs.dart';
import 'package:cloud_water/model/weather.dart';
import 'package:http/http.dart' as http;

class CloudWaterService {
  http.Client client = http.Client();

  Future<HomeOptions?> getHomeOptions() async {
    HomeOptions? options;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      options = HomeOptions.fromRawJson(_homeOptionsJSON);
    } catch (e) {
      options = null;
    }

    return options;
  }

  Future<bool> updateFaucetStatus(bool status) async {
    bool isSuccess;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }

    return isSuccess;
  }

  Future<bool> updateConfig(Config config) async {
    bool isSuccess;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }

    return isSuccess;
  }

  Future<List<Log>?> getLogs() async {
    List<Log>? logs;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      logs = [];
      final jsonBody = json.decode(_logsJSON);
      for (final i in jsonBody) {
        logs.add(Log.fromJson(i));
      }
    } catch (e) {
      print('error getting logs: $e');
      logs = null;
    }

    return logs;
  }

  Future<WeatherPrediction?> getWeatherPrediction() async {
    WeatherPrediction? prediction;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 1));
      prediction = WeatherPrediction.fromRawJson(_weatherJson);
    } catch (e) {
      prediction = null;
    }
    return prediction;
  }

  Future<bool> addDevice(String name, String serial) async {
    bool isSuccess;
    try {
      await Future<dynamic>.delayed(const Duration(seconds: 3));
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }

    return isSuccess;
  }
}

final String _homeOptionsJSON = """
{
  "faucet_on": true,
  "soil_read": [
    {
      "name": "Jardim Frontal",
      "value": 0.001,
      "status": "low"
    },
    {
      "name": "Jardim Interno",
      "value": 0.023,
      "status": "normal"
    },
    {
      "name": "Jardim Exterior",
      "value": 0.05,
      "status": "high"
    }
  ],
  "config": [
    {
      "name": "Ativar com base na umidade do solo",
      "value": true
    },
    {
      "name": "Ativar com base no horario",
      "value": false
    },
    {
      "name": "Não ativar em dias chuvosos",
      "value": false
    }
  ]
}
""";

final String _logsJSON = """
[
  {
    "name": "08/09/21 - 14:30",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 14:00",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 13:30",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 13:00",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 12:30",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 12:00",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  },
  {
    "name": "08/09/21 - 11:30",
    "value": "Umidade Jardim Frontal - 0,020\\nUmidade Jardim Exterior - 0,020\\nUmidade Jardim Interno - 0,020"
  }
]
""";

final String _weatherJson = """
{
  "today": {
    "min": 24,
    "max": 32,
    "current": 28,
    "status": "Parcialmente Nublado",
    "uv": "Alto",
    "humidity": 72,
    "rain_chance": 7
  },
  "yesterday": {
    "min": 24,
    "max": 32,
    "current": null,
    "status": null,
    "uv": null,
    "humidity": null,
    "rain_chance": 7
  },
  "tomorrow": {
    "min": 24,
    "max": 32,
    "current": null,
    "status": null,
    "uv": null,
    "humidity": null,
    "rain_chance": 7
  }
}
""";
