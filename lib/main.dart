import 'package:cloud_water/view/home/home_view.dart';
import 'package:cloud_water/view/home/home_view_model.dart';
import 'package:cloud_water/view/login/login_view.dart';
import 'package:cloud_water/view/login/login_view_model.dart';
import 'package:cloud_water/view/logs/logs_view.dart';
import 'package:cloud_water/view/logs/logs_view_model.dart';
import 'package:cloud_water/view/weather/weather_view.dart';
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
          create: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LogsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherViewModel(),
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
      home: LoginView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    LogsView(),
    WeatherView(),
  ];

  void _showAddIOT() {
    //TODO: navigate to add iot view
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Water'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddIOT,
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
