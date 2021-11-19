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
            FirestoreSettingsConfig.fromFirestore(settingsSnapshot['config']));
  }
}

class FirestoreSettingsConfig {
  FirestoreSettingsConfig({
    required this.id,
    required this.isActive,
  });

  String id;
  bool isActive;

  static List<FirestoreSettingsConfig> fromFirestore(
      Map<String, dynamic> configSnapshot) {
    List<FirestoreSettingsConfig> configs = [];

    configSnapshot.forEach((key, value) {
      configs.add(FirestoreSettingsConfig(id: key, isActive: value));
    });

    return configs;
  }
}
