import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/service/cloud_water_service.dart';
import 'package:cloud_water/view/main/main_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddIotViewModel extends ChangeNotifier {
  CloudWaterService _cloudWaterService = CloudWaterService();

  ApiStatus? _apiStatus;

  ApiStatus? get apiStatus => _apiStatus;

  bool isMainIot = false;

  bool _showSuccessDialog = false;

  bool get showSuccessDialog => _showSuccessDialog;

  late BuildContext _context;

  void updateContext(BuildContext c) {
    _context = c;
  }

  void onAddDeviceClick(String name, String serial) async {
    _apiStatus = ApiStatus.LOADING;
    notifyListeners();
    bool isSuccess;

    if (isMainIot) {
      isSuccess = await _cloudWaterService.addMainIot(serial);
    } else {
      //TODO: add aux iot
      isSuccess = await _cloudWaterService.addAuxIot(name, serial);
    }

    if (isSuccess) {
      _apiStatus = ApiStatus.DONE;
      _showSuccessDialog = true;
    } else {
      _apiStatus = ApiStatus.ERROR;
    }

    notifyListeners();
  }

  void onSuccessDialogClick() async {
    if (isMainIot) {
      await Provider.of<MainViewModel>(_context, listen: false).getPreviousUser();
    }
    isMainIot = false;
    _showSuccessDialog = false;
    notifyListeners();
  }
}
