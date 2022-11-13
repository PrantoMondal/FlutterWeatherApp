import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/pages/settings_page.dart';
import 'package:weather_app_flutter/pages/weather_page.dart';
import 'package:weather_app_flutter/providers/weather_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Merriweather',
      ),
      initialRoute: WeatherPage.routeName,
      routes: {
        WeatherPage.routeName:(_) => WeatherPage(),
        SettingsPage.routeName:(_) => SettingsPage(),
      },
    );
  }
}