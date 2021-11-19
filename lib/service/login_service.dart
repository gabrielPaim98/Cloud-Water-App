import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_water/instances.dart';
import 'package:cloud_water/model/firestore_user.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  CloudWaterService _cloudWaterService = CloudWaterService();

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

  Future<LoginResult> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential? user;
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    try {
      user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      result = LoginResult.SUCCESS;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        result = LoginResult.WRONG_CREDENTIAL;
        user = null;
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        result = LoginResult.WRONG_CREDENTIAL;
        user = null;
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      user = null;
      result = LoginResult.WRONG_CREDENTIAL;
      print('Error sign in with email and password: $e');
    }
    Instances.user = user?.user;
    print('user: ${user?.user?.uid}');
    return result;
  }

  Future<LoginResult> signInAnonymously(
      String name, String lat, String lng) async {
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    try {
      UserCredential user = await Instances.firebaseAuth.signInAnonymously();
      Instances.user = user.user;
      print('user: ${user.user?.uid}');

      if (user.user != null) {
        var userDocCreated = await createUserDoc(lat, lng, name);
        if (userDocCreated) {
          result = LoginResult.SUCCESS;
        } else {
          Instances.user = null;
          result = LoginResult.WRONG_CREDENTIAL;
        }
      }
    } catch (e) {
      print('Error logging in anonymously: $e');
      result = LoginResult.WRONG_CREDENTIAL;
    }

    return result;
  }

  Future<LoginResult> createUserWithEmailAndPassword(String email,
      String password, String name, String lat, String lng) async {
    LoginResult result = LoginResult.WRONG_CREDENTIAL;
    UserCredential? user;
    try {
      user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Instances.user = user.user;
      if (user.user != null) {
        var userDocCreated = await createUserDoc(lat, lng, name);
        if (userDocCreated) {
          result = LoginResult.SUCCESS;
        } else {
          Instances.user = null;
          result = LoginResult.WRONG_CREDENTIAL;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        result = LoginResult.WEAK_PASSWORD;
        user = null;
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        result = LoginResult.EMAIL_IN_USE;
        user = null;
        print('The account already exists for that email.');
      }
    } catch (e) {
      result = LoginResult.WRONG_CREDENTIAL;
      user = null;
      print('Error creating user with email and password: $e');
    }
    return result;
  }

  Future<User?> currentUser() async {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print('failed to get current user: $e');
      user = null;
    }
    Instances.user = user;
    print('user: ${user?.uid}');
    return user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Instances.user = null;
  }

  Future<bool> createUserDoc(String lat, String lng, String name) async {
    bool isSuccess = false;
    try {
      var allConfigs = await _cloudWaterService.getFirestoreConfigs();
      print('userId: $userId');
      usersFirestore.doc(userId).set(
          FirestoreUser.withDefaultSettings(lat, lng, name, allConfigs)
              .toJson());
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
      print('Error creating user doc: $e');
    }
    return isSuccess;
  }
}

enum LoginResult { SUCCESS, WRONG_CREDENTIAL, WEAK_PASSWORD, EMAIL_IN_USE }
