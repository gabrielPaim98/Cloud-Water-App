import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_water/instances.dart';
import 'package:cloud_water/model/firestore_config.dart';
import 'package:cloud_water/model/firestore_main_iot.dart';
import 'package:cloud_water/model/firestore_user.dart';
import 'package:cloud_water/model/home_options.dart';
import 'package:cloud_water/model/logs.dart';
import 'package:cloud_water/model/weather.dart';
import 'package:http/http.dart' as http;

class CloudWaterService {
  http.Client client = http.Client();
  String? _userId;

  String get userId {
    if (_userId == null) {
      _userId = Instances.user!.uid;
    }
    return _userId!;
  }

  FirebaseFirestore firestore = Instances.firestore;

  CollectionReference? _configFirestore;

  CollectionReference get configFirestore {
    if (_configFirestore == null) {
      _configFirestore = firestore.collection('config');
    }

    return _configFirestore!;
  }

  CollectionReference? _mainIotFirestore;

  CollectionReference get mainIotFirestore {
    if (_mainIotFirestore == null) {
      _mainIotFirestore = firestore.collection('main_iot');
    }

    return _mainIotFirestore!;
  }

  CollectionReference? _usersFirestore;

  CollectionReference get usersFirestore {
    if (_usersFirestore == null) {
      _usersFirestore = firestore.collection('users');
    }

    return _usersFirestore!;
  }

  Future<HomeOptions?> getHomeOptions() async {
    HomeOptions? options;
    try {
      var firestoreUser = await getFirestoreUser();
      var firestoreConfig = await getFirestoreConfigs();
      var firestoreMainIot = await getFirestoreMainIot();

      options = HomeOptions.fromFirestore(
          firestoreUser, firestoreConfig, firestoreMainIot);
    } catch (e) {
      options = null;
      print('error getting home options: $e');
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
      logs = Log.fromFirestore(await getFirestoreMainIot());
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

  Future<FirestoreUser> getFirestoreUser() async {
    var userData = await usersFirestore.doc(userId).get()
        as DocumentSnapshot<Map<String, dynamic>>;
    return FirestoreUser.fromFirestore(userData.data()!);
  }

  Future<List<FirestoreConfig>> getFirestoreConfigs() async {
    var configData = await configFirestore.doc('config').get()
        as DocumentSnapshot<Map<String, dynamic>>;
    return FirestoreConfig.fromFirestore(configData.data()!);
  }

  Future<FirestoreMainIot> getFirestoreMainIot() async {
    var mainIotData = await mainIotFirestore
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get() as QuerySnapshot<Map<String, dynamic>>;
    return FirestoreMainIot.fromFirestore(mainIotData.docs.first.data());
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
