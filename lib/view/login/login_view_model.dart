import 'package:cloud_water/service/login_service.dart';
import 'package:cloud_water/view/main/main_view.dart';
import 'package:cloud_water/view/main/main_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  bool _showIncorrectCredential = false;

  bool get showIncorrectCredential => _showIncorrectCredential;

  late BuildContext _context;

  LoginService _loginService = LoginService();

  void updateContext(BuildContext c) {
    _context = c;
  }

  void navigateHome() {
    Provider.of<MainViewModel>(_context, listen: false).getPreviousUser();

    // Navigator.pushAndRemoveUntil(_context,
    //     MaterialPageRoute(builder: (context) => MainView()), (route) => false);
  }

  void onLoginClick(String email, String password) async {
    LoginResult result =
        await _loginService.signInWithEmailAndPassword(email, password);

    if (result == LoginResult.SUCCESS) {
      navigateHome();
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
