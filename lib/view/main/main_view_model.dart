import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:cloud_water/service/login_service.dart';
import 'package:cloud_water/view/home/home_view_model.dart';
import 'package:cloud_water/view/logs/logs_view_model.dart';
import 'package:cloud_water/view/weather/weather_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../instances.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel() {
    _initFirebase();
  }
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _hasMainDevice = false;
  bool get hasMainDevice => _hasMainDevice;

  ApiStatus _apiStatus = ApiStatus.LOADING;

  ApiStatus get apiStatus => _apiStatus;

  LoginService _loginService = LoginService();

  CloudWaterService _cloudWaterService = CloudWaterService();

  void _initFirebase() async {
    Instances.firebaseApp = await Firebase.initializeApp();
    getPreviousUser();
  }

  Future<void> getPreviousUser() async {
    User? user = await _loginService.currentUser();
    print('currentUser: ${user?.uid}');
    _isLoggedIn = user != null;

    print('isLoggedIn? $_isLoggedIn');
    if (!_isLoggedIn) {
      _apiStatus = ApiStatus.DONE;
      notifyListeners();
      return;
    }

    try {
      var device = await _cloudWaterService.getFirestoreMainIot();
      print('device: ${device.serial}');
      _hasMainDevice = true;
    } catch (e) {
      _hasMainDevice = false;
    }

    print('hasMainDevice? $_hasMainDevice');
    _apiStatus = ApiStatus.DONE;
    notifyListeners();
  }

  void onBnbItemClick(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void addMainDevice() {
    _hasMainDevice = true;
    notifyListeners();
  }

  void refresh(BuildContext context) {
    if (_selectedIndex == 0) {
      Provider.of<HomeViewModel>(context, listen: false).getConfig();
    } else if (_selectedIndex  == 1) {
      Provider.of<LogsViewModel>(context, listen: false).getLogs();
    } else if (_selectedIndex == 2) {
      Provider.of<WeatherViewModel>(context, listen: false).getWeatherPrediction();
    }
  }
}
