import 'firestore_config.dart';

class FirestoreUser {
  FirestoreUser({
    required this.lat,
    required this.lng,
    required this.name,
    required this.settings,
  });

  String lat;
  String lng;
  String name;
  FirestoreSettings settings;

  factory FirestoreUser.fromFirestore(Map<String, dynamic> userSnapshot) {
    return FirestoreUser(
        lat: userSnapshot['lat'],
        lng: userSnapshot['lng'],
        name: userSnapshot['name'],
        settings: FirestoreSettings.fromFirestore(userSnapshot['settings']));
  }

  factory FirestoreUser.withDefaultSettings(
      String lat, String lng, String name, List<FirestoreConfig> configs) {
    return FirestoreUser(
      lat: lat,
      lng: lng,
      name: name,
      settings: FirestoreSettings.withDefaultValues(configs),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': this.lat,
      'lng': this.lng,
      'name': this.name,
      'settings': this.settings.toJson()
    };
  }
}

class FirestoreSettings {
  FirestoreSettings({
    required this.faucetOn,
    required this.settingsConfig,
  });

  List<FirestoreSettingsConfig> settingsConfig;
  bool faucetOn;

  factory FirestoreSettings.fromFirestore(
      Map<String, dynamic> settingsSnapshot) {
    return FirestoreSettings(
      faucetOn: settingsSnapshot['faucet_on'],
      settingsConfig:
          FirestoreSettingsConfig.fromFirestore(settingsSnapshot['config']),
    );
  }

  factory FirestoreSettings.withDefaultValues(List<FirestoreConfig> configs) {
    return FirestoreSettings(
      faucetOn: false,
      settingsConfig: FirestoreSettingsConfig.withDefaultValues(configs),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'faucet_on': this.faucetOn,
      'config': List<dynamic>.from(this.settingsConfig.map((x) => x.toJson())),
    };
  }
}

class FirestoreSettingsConfig {
  FirestoreSettingsConfig({
    required this.id,
    required this.isActive,
  });

  String id;
  bool isActive;

  static List<FirestoreSettingsConfig> withDefaultValues(
      List<FirestoreConfig> availableConfigs) {
    List<FirestoreSettingsConfig> configs = [];

    availableConfigs.forEach((e) {
      configs.add(FirestoreSettingsConfig(id: e.id, isActive: false));
    });

    return configs;
  }

  static List<FirestoreSettingsConfig> fromFirestore(
      Map<String, dynamic> configSnapshot) {
    List<FirestoreSettingsConfig> configs = [];

    configSnapshot.forEach((key, value) {
      configs.add(FirestoreSettingsConfig(id: key, isActive: false));
    });

    return configs;
  }

  Map<String, dynamic> toJson() {
    return {this.id: this.isActive};
  }
}
