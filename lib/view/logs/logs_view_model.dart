import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/model/logs.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:flutter/foundation.dart';

class LogsViewModel extends ChangeNotifier {
  LogsViewModel() {
    getLogs();
  }

  CloudWaterService _cloudWaterService = CloudWaterService();

  ApiStatus _apiStatus = ApiStatus.LOADING;

  ApiStatus get apiStatus => _apiStatus;

  late List<Log> _logs;

  List<Log> get logs => _logs;

  Future<void> getLogs() async {
    _apiStatus = ApiStatus.LOADING;
    notifyListeners();
    try {
      _logs = (await _cloudWaterService.getLogs())!;
      _apiStatus = ApiStatus.DONE;
    } catch (e) {
      _apiStatus = ApiStatus.ERROR;
    }
    notifyListeners();
  }
}
