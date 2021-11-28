import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/model/weather.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:flutter/foundation.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel() {
    getWeatherPrediction();
  }

  CloudWaterService _cloudWaterService = CloudWaterService();

  ApiStatus _apiStatus = ApiStatus.LOADING;

  ApiStatus get apiStatus => _apiStatus;

  late WeatherPrediction _prediction;

  WeatherPrediction get prediction => _prediction;

  Future<void> getWeatherPrediction() async {
    _apiStatus = ApiStatus.LOADING;
    notifyListeners();
    try {
      _prediction = (await _cloudWaterService.getWeatherPrediction())!;
      _apiStatus = ApiStatus.DONE;
    } catch (e, stacktrace) {
      _apiStatus = ApiStatus.ERROR;
      print('error getting weather prediction $e $stacktrace');
    }
    notifyListeners();
  }
}
