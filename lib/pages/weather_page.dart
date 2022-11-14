import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_flutter/providers/weather_provider.dart';
import 'package:weather_app_flutter/utils/constants.dart';
import 'package:weather_app_flutter/utils/helper_functions.dart';
import 'package:weather_app_flutter/utils/text_style.dart';

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
    if(isFirst) {
      provider = Provider.of<WeatherProvider>(context);
      _detectLocation();
      isFirst = false;
    }
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
        child: provider.hasDataLoaded ? ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          children: [
            _currentWeatherSection(),
            _forecastWeatherSection(),
          ],
        ) :
        const Text('Please wait'),
      ),
    );
  }

  void _detectLocation() {
    determinePosition().then((position) {
      provider.setNewLocation(position.latitude, position.longitude);
      provider.getWeatherData();
    });
  }

  Widget _currentWeatherSection() {
    final current = provider.currentResponseModel;
    return Column(
      children: [
        Text(getFormattedDateTime(current!.dt!, 'MMM dd, yyyyy',), style: txtDateBig18,),
        Text('${current.name}, ${current.sys!.country}', style: txtAddress25,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network('$iconPrefix${current.weather![0].icon}$iconSuffix', fit: BoxFit.cover,),
              Text('${current.main!.temp!.round()}$degree${provider.unitSymbol}', style: txtTempBig80,),
            ],
          ),
        ),
        Text('feels like ${current.main!.feelsLike}$degree${provider.unitSymbol}', style: txtNormal16White54,),
        Text('${current.weather![0].main} ${current.weather![0].description}', style: txtNormal16White54,),
        const SizedBox(height: 20,),
        Wrap(
          children: [
            Text('Humidity : ${current.main!.humidity}% \t', style: txtNormal16,),
            Text('Pressure : ${current.main!.pressure} hPa \t', style: txtNormal16,),
            Text('Visibility : ${current.visibility} meter \t', style: txtNormal16,),
            Text('Wind Speed : ${current.wind!.speed} meter/sec \t', style: txtNormal16,),
            Text('Degree : ${current.wind!.deg}$degree \t', style: txtNormal16,),
          ],
        ),
        const SizedBox(height: 20,),
        Wrap(
          children: [
            Text('Sunrise: ${getFormattedDateTime(current.sys!.sunrise!, 'hh:mm a')}', style: txtNormal16White54,),
            const SizedBox(width: 10,),
            Text('Sunset: ${getFormattedDateTime(current.sys!.sunset!, 'hh:mm a')}', style: txtNormal16White54,),
          ],
        )
      ],
    );
  }

  Widget _forecastWeatherSection() {
    final forecast = provider.forecastResponseModel;

    return Column(
      children: forecast.list!
          .map((item) => dailyWidget(item, context))
          .toList(),

    );
  }
}
