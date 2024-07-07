import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class TabletWeatherScreen extends StatelessWidget {
  const TabletWeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Weather weather = ModalRoute.of(context)!.settings.arguments as Weather;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text(
              '${weather.temperatureInCelsius().toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            Text(
              weather.weatherCondition,
              style: const TextStyle(fontSize: 24),
            ),
            Image.network('http://openweathermap.org/img/w/${weather.icon}.png'),
            Text(
              'Humidity: ${weather.humidity}%',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Wind Speed: ${weather.windSpeed} m/s',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
