import 'package:cloud_water/service/login_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  LoginService _loginService = LoginService();

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<void> onRegisterClick(
      String email, String password, String name) async {
    Position userPos = await getUserLocation();
    print('email: $email');
    print('senha: $password');
    print('nome: $name');
    print('position: ${userPos.latitude}, ${userPos.longitude}');
  }

  Future<void> onAnonymousRegisterClick(String name) async {
    Position userPos = await getUserLocation();
    print('nome: $name');
    print('position: ${userPos.latitude}, ${userPos.longitude}');
  }

  Future<Position> getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
