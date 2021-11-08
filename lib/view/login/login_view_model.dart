import 'package:cloud_water/instances.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel() {
    _initFirebase();
  }

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _shouldNavigateHome = false;
  bool get shouldNavigateHome => _shouldNavigateHome;

  void _initFirebase() async {
    Instances.firebaseApp = await Firebase.initializeApp();
  }

  void onLoginClick(String email, String password) async {
    try {
      Instances.userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      navigateHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> onAnonymousLoginClick() async {
    Instances.userCredential = await Instances.firebaseAuth.signInAnonymously();
    navigateHome();
    print('user: ${Instances.userCredential?.user?.uid}');
  }

  void onRegisterClick(String email, String password) async {
    try {
      Instances.userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      navigateHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void navigateHome() {
    _shouldNavigateHome = true;
    notifyListeners();
  }
}
