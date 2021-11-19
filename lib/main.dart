import 'package:cloud_water/view/add_iot/add_iot_view_model.dart';
import 'package:cloud_water/view/home/home_view_model.dart';
import 'package:cloud_water/view/login/login_view_model.dart';
import 'package:cloud_water/view/logs/logs_view_model.dart';
import 'package:cloud_water/view/main/main_view.dart';
import 'package:cloud_water/view/main/main_view_model.dart';
import 'package:cloud_water/view/register/register_view_model.dart';
import 'package:cloud_water/view/weather/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LogsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddIotViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Water',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(),
      home: MainView(),
    );
  }
}
