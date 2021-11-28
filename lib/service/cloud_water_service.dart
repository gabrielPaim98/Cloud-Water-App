import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_water/instances.dart';
import 'package:cloud_water/model/firestore_config.dart';
import 'package:cloud_water/model/firestore_main_iot.dart';
import 'package:cloud_water/model/firestore_user.dart';
import 'package:cloud_water/model/home_options.dart';
import 'package:cloud_water/model/logs.dart';
import 'package:cloud_water/model/weather.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
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
    bool isSuccess = false;
    try {
      await usersFirestore
          .doc(userId)
          .update({'settings.faucet_on': status}).then((value) {
        isSuccess = true;
      }).catchError((e) {
        isSuccess = false;
        print('error updating faucet status: $e');
      });
    } catch (e) {
      isSuccess = false;
      print('error updating faucet status: $e');
    }

    return isSuccess;
  }

  Future<bool> updateConfig(Config config) async {
    bool isSuccess = false;
    try {
      await usersFirestore
          .doc(userId)
          .update({'settings.config.${config.id}': config.value}).then((value) {
        isSuccess = true;
      }).catchError((e) {
        isSuccess = false;
        print('error updating config status: $e');
      });
    } catch (e) {
      isSuccess = false;
      print('error updating config status: $e');
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
      // await Future<dynamic>.delayed(const Duration(seconds: 1));
      // prediction = WeatherPrediction.fromRawJson(_weatherJson);

      var u = await getFirestoreUser();

      print('user lat: ${u.lat} lng: ${u.lng}');

      final Uri uri = Uri.parse(
          'https://us-central1-cloud-water-ac2cb.cloudfunctions.net/forecast');
      final Map<String, String> headers = <String, String>{
        'Accept': 'application/json'
      };
      final Map<String, dynamic> body = {'lat': u.lat, 'lng': u.lng};
      final http.Response response =
          await http.post(uri, headers: headers, body: body);

      print('res: ${response.statusCode} ${response.body}');
      if (response.statusCode != 200) {
        return null;
      }

      prediction = WeatherPrediction.fromRawJson(response.body);
    } catch (e, stacktrace) {
      print('error weather prediction $e $stacktrace');
      prediction = null;
    }
    return prediction;
  }

  Future<bool> addAuxIot(String name, String serial) async {
    bool isSuccess;
    try {
      String uuid = UniqueKey()
          .toString()
          .replaceAll('[', '')
          .replaceAll('#', '')
          .replaceAll(']', '');
      print('uuid: $uuid');

      var mainIotData = await mainIotFirestore
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      var mainId = mainIotData.docs.first.id;

      print('mainId: $mainId');

      Map<String, dynamic> auxIot = {
        'name': name,
        'serial': serial,
      };

      await mainIotFirestore
          .doc(mainId)
          .update({'aux_iot.$uuid': auxIot}).then((value) {
        isSuccess = true;
      }).catchError((e) {
        isSuccess = false;
        print('error adding aux iot: $e');
      });

      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      print('error adding aux iot: $e');
    }

    return isSuccess;
  }

  Future<bool> addMainIot(String serial) async {
    bool isSuccess;
    try {
      await mainIotFirestore
          .add(FirestoreMainIot.withDefaultValue(serial, userId).toJson());
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      print('error adding main iot: $e');
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

final String _weatherJson = """
{
  "today": {
    "min": 24.85,
    "max": 27.61,
    "current": 26.96,
    "status": "nuvens dispersas",
    "uv": "Baixo",
    "humidity": 61,
    "rain_chance": 5.87
  },
  "tomorrow": {
    "min": 24.48,
    "max": 26.96,
    "current": null,
    "status": null,
    "uv": null,
    "humidity": null,
    "rain_chance": 1.01
  }
}
""";
