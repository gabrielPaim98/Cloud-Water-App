import 'package:cloud_water/service/login_service.dart';
import 'package:flutter/foundation.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _showIncorrectCredential = false;
  bool get showIncorrectCredential => _showIncorrectCredential;

  bool _shouldNavigateHome = false;
  bool get shouldNavigateHome => _shouldNavigateHome;

  LoginService _loginService = LoginService();

  void onLoginClick(String email, String password) async {
    LoginResult result =
        await _loginService.signInWithEmailAndPassword(email, password);

    if (result == LoginResult.SUCCESS) {
      _shouldNavigateHome = true;
    } else {
      _showIncorrectCredential = true;
    }
    notifyListeners();
  }

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}
