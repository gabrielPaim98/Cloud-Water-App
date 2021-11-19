class FirestoreConfig {
  FirestoreConfig({
    required this.id,
    required this.name,
    required this.info,
  });

  String id;
  String info;
  String name;

  static List<FirestoreConfig> fromFirestore(
      Map<String, dynamic> configSnapshot) {
    List<FirestoreConfig> configs = [];

    configSnapshot.forEach((key, value) {
      configs.add(
          FirestoreConfig(id: key, name: value['name'], info: value['info']));
    });

    return configs;
  }
}
