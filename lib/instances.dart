import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Instances {
  static FirebaseApp? firebaseApp;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static User? user;
}
