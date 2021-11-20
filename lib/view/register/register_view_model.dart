import 'package:cloud_water/service/login_service.dart';
import 'package:cloud_water/view/main/main_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  bool _showRegistryError = false;

  bool get showRegistryError => _showRegistryError;

  String _errorMsg = '';

  String get errorMsg => _errorMsg;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  late BuildContext _context;

  LoginService _loginService = LoginService();

  void updateContext(BuildContext c) {
    _context = c;
  }

  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void navigateHome() async {
    await Provider.of<MainViewModel>(_context, listen: false).getPreviousUser();
    Navigator.pop(_context);
  }

  Future<void> onRegisterClick(
      String email, String password, String name) async {
    _showRegistryError = false;
    _isLoading = true;
    notifyListeners();

    Position userPos = await getUserLocation();
    print('email: $email');
    print('senha: $password');
    print('nome: $name');
    print('position: ${userPos.latitude}, ${userPos.longitude}');

    if (email.isEmpty) {
      _errorMsg = 'Por favor preencha o email';
      _showRegistryError = true;
      notifyListeners();
      return;
    }

    if (password.isEmpty) {
      _errorMsg = 'Por favor preencha a senha';
      _showRegistryError = true;
      notifyListeners();
      return;
    }

    if (name.isEmpty) {
      _errorMsg = 'Por favor preencha o nome';
      _showRegistryError = true;
      notifyListeners();
      return;
    }

    LoginResult result = await _loginService.createUserWithEmailAndPassword(
        email,
        password,
        name,
        userPos.latitude.toString(),
        userPos.longitude.toString());

    if (result == LoginResult.SUCCESS) {
      navigateHome();
      return;
    } else {
      _errorMsg = result == LoginResult.EMAIL_IN_USE
          ? 'Email em uso'
          : result == LoginResult.WEAK_PASSWORD
              ? 'Senha fraca'
              : 'Ocorreu um erro ao criar a sua conta';
      _showRegistryError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> onAnonymousRegisterClick(String name) async {
    _showRegistryError = false;
    _isLoading = true;
    notifyListeners();

    Position userPos = await getUserLocation();
    print('nome: $name');
    print('position: ${userPos.latitude}, ${userPos.longitude}');

    if (name.isEmpty) {
      _errorMsg = 'Por favor preencha o nome';
      _showRegistryError = true;
      notifyListeners();
      return;
    }

    LoginResult result = await _loginService.signInAnonymously(
        name, userPos.latitude.toString(), userPos.longitude.toString());

    if (result == LoginResult.SUCCESS) {
      navigateHome();
      return;
    } else {
      _errorMsg = 'Ocorreu um erro ao criar a sua conta';
      _showRegistryError = true;
    }
    _isLoading = false;
    notifyListeners();
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
