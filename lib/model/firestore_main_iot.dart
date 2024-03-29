import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMainIot {
  FirestoreMainIot({
    required this.auxIot,
    required this.lastSoilRead,
    required this.log,
    required this.userId,
    required this.serial,
  });

  List<FirestoreLog> log;
  List<FirestoreLastSoilRead> lastSoilRead;
  List<FirestoreAuxIot> auxIot;
  String serial;
  String userId;

  factory FirestoreMainIot.fromFirestore(Map<String, dynamic> iotSnapshot) {
    return FirestoreMainIot(
      auxIot: FirestoreAuxIot.fromFirestore(iotSnapshot['aux_iot']),
      lastSoilRead:
          FirestoreLastSoilRead.fromFirestore(iotSnapshot['last_soil_read']),
      log: FirestoreLog.fromFirestore(iotSnapshot['logs']),
      userId: iotSnapshot['user_id'],
      serial: iotSnapshot['serial'],
    );
  }

  factory FirestoreMainIot.withDefaultValue(String serial, String userId) {
    return FirestoreMainIot(
      auxIot: [],
      lastSoilRead: [],
      log: [],
      userId: userId,
      serial: serial,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> emptyMap = {};
    return {
      'aux_iot': this.auxIot.isEmpty
          ? emptyMap
          : List<dynamic>.from(this.auxIot.map((x) => x.toJson())),
      'last_soil_read':
          this.lastSoilRead.isEmpty ? emptyMap : this.lastSoilRead,
      'logs': this.lastSoilRead,
      'serial': this.serial,
      'user_id': this.userId,
    };
  }
}

class FirestoreAuxIot {
  FirestoreAuxIot({
    required this.id,
    required this.name,
    required this.serial,
  });

  String id;
  String name;
  String serial;

  static List<FirestoreAuxIot> fromFirestore(Map<String, dynamic> iotSnapshot) {
    List<FirestoreAuxIot> iots = [];

    iotSnapshot.forEach((key, value) {
      iots.add(FirestoreAuxIot(
          id: key, name: value['name'], serial: value['serial']));
    });

    return iots;
  }

  Map<String, dynamic> toJson() {
    return {
      this.id: {
        'name': this.name,
        'serial': this.serial,
      }
    };
  }
}

class FirestoreLastSoilRead {
  FirestoreLastSoilRead({
    required this.name,
    required this.value,
    required this.status,
  });

  String name;
  String status;
  double value;

  static List<FirestoreLastSoilRead> fromFirestore(
      Map<String, dynamic> soilSnapshot) {
    List<FirestoreLastSoilRead> reads = [];

    soilSnapshot.forEach((key, value) {
      reads.add(FirestoreLastSoilRead(
          name: key, value: value['value'], status: value['status']));
    });

    return reads;
  }
}

class FirestoreLog {
  FirestoreLog({
    required this.id,
    required this.msg,
    required this.timeStamp,
  });

  int id;
  String msg;
  String timeStamp;

  static List<FirestoreLog> fromFirestore(List<dynamic> logSnapshot) {
    List<FirestoreLog> logs = [];

    for (var i = 0; i < logSnapshot.length; i++) {
      var value = logSnapshot[i];
      var timestamp = (value['timestamp'] as Timestamp).toDate();
      String timestampString =
          '${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';

      logs.add(FirestoreLog(
        id: i,
        msg: value['msg'].toString().replaceAll('\\n', '\n'),
        timeStamp: timestampString,
      ));
    }

    return logs.reversed.toList();
  }
}
