import 'package:cloud_water/service/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _shouldNavigateHome = false;
  bool get shouldNavigateHome => _shouldNavigateHome;

  LoginService _loginService = LoginService();

  void onLoginClick(String email, String password) async {
    UserCredential? user =
        await _loginService.signInWithEmailAndPassword(email, password);
    if (user != null) {
      navigateHome();
    } else {
      //TODO: Show error
    }
  }

  Future<void> onAnonymousLoginClick() async {
    UserCredential? user = await _loginService.signInAnonymously();
    if (user != null) {
      navigateHome();
    } else {
      //TODO: Show error
    }
  }

  void onRegisterClick(String email, String password) async {
    UserCredential? user =
        await _loginService.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      navigateHome();
    } else {
      //TODO: Show error
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
