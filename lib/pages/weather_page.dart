import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/providers/weather_provider.dart';

import '../utils/location_service.dart';

class WeatherPage extends StatefulWidget {
  static String routeName = '/';

  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherProvider provider;
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    provider = Provider.of<WeatherProvider>(context);
    _detectLocation();
    isFirst = false;

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: provider.hasDataLoaded? ListView() : 
        const Text('Please wait'),
      ),
    );
  }

  void _detectLocation() {
    determinePosition().then((position){
      provider.setNewLocation(position.latitude, position.longitude);
      provider.getWeatherData();
    });
  }
}
