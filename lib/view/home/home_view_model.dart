import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/model/home_options.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    getConfig();
  }

  CloudWaterService _cloudWaterService = CloudWaterService();

  ApiStatus _apiStatus = ApiStatus.LOADING;

  ApiStatus get apiStatus => _apiStatus;

  late HomeOptions _homeOptions;

  HomeOptions get homeOptions => _homeOptions;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getConfig() async {
    _apiStatus = ApiStatus.LOADING;
    notifyListeners();
    try {
      _homeOptions = (await _cloudWaterService.getHomeOptions())!;
      _apiStatus = ApiStatus.DONE;
    } catch (e) {
      _apiStatus = ApiStatus.ERROR;
    }
    notifyListeners();
  }

  Future<void> updateFaucetStatus(bool isActive) async {
    _isLoading = true;
    _homeOptions.faucetOn = isActive;
    notifyListeners();
    await _cloudWaterService.updateFaucetStatus(isActive);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateConfig(int index, bool value) async {
    _isLoading = true;
    _homeOptions.config.elementAt(index).value = value;
    notifyListeners();
    await _cloudWaterService.updateConfig(_homeOptions.config.elementAt(index));
    _isLoading = false;
    notifyListeners();
  }
}
