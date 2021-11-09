import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:flutter/foundation.dart';

class AddIotViewModel extends ChangeNotifier {
  CloudWaterService _cloudWaterService = CloudWaterService();

  ApiStatus? _apiStatus;

  ApiStatus? get apiStatus => _apiStatus;

  void onAddDeviceClick(String name, String serial) async {
    _apiStatus = ApiStatus.LOADING;
    notifyListeners();
    bool isSuccess = await _cloudWaterService.addDevice(name, serial);
    if (isSuccess) {
      _apiStatus = ApiStatus.DONE;
    } else {
      _apiStatus = ApiStatus.ERROR;
    }
    notifyListeners();
  }
}
