import 'package:cloud_water/model/api_status.dart';
import 'package:cloud_water/util/colors.dart';
import 'package:cloud_water/view/add_iot/add_iot_view.dart';
import 'package:cloud_water/view/home/home_view.dart';
import 'package:cloud_water/view/login/login_view.dart';
import 'package:cloud_water/view/logs/logs_view.dart';
import 'package:cloud_water/view/main/main_view_model.dart';
import 'package:cloud_water/view/weather/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    LogsView(),
    WeatherView(),
  ];

  void _showAddIOT(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddIotView()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return viewModel.apiStatus == ApiStatus.LOADING
            ? Scaffold(
                backgroundColor: BLUE,
                body: Center(
                  child: Text('Cloud Water'),
                ),
              )
            : !viewModel.isLoggedIn
                ? LoginView()
                : viewModel.hasMainDevice
                    ? AddIotView()
                    : Scaffold(
                        appBar: AppBar(
                          title: Text('Cloud Water'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _showAddIOT(context),
                            )
                          ],
                        ),
                        body: _widgetOptions.elementAt(viewModel.selectedIndex),
                        bottomNavigationBar: BottomNavigationBar(
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.home),
                              label: 'Início',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.library_books),
                              label: 'Histórico',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.cloud),
                              label: 'Clima',
                            ),
                          ],
                          currentIndex: viewModel.selectedIndex,
                          onTap: viewModel.onBnbItemClick,
                        ),
                      );
      },
    );
  }
}
