// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/blocs/weather/weather_bloc.dart';
import 'package:skyguru/blocs/weather/weather_event.dart';
import 'package:skyguru/blocs/weather/weather_state.dart';
import 'package:skyguru/repositories/weather_repository.dart';
import '../../models/weather_model.dart';

class MobileWeatherScreen extends StatefulWidget {
  const MobileWeatherScreen({super.key});

  @override
  State<MobileWeatherScreen> createState() => _MobileWeatherScreenState();
}

class _MobileWeatherScreenState extends State<MobileWeatherScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final WeatherBloc _weatherBloc = WeatherBloc(weatherRepository: WeatherRepository());
  double _offset = -50.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _weatherBloc.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Weather weather = ModalRoute.of(context)!.settings.arguments as Weather;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/background_p.jpg'),
            fit: BoxFit.cover,
          ),
          ),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                weather.cityName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: Icon(
                Icons.menu,
                color: Colors.white,
                size: 10.w,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    // _locateMe();
                  },
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 4.5.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    _weatherBloc.add(
                      RefreshWeather(cityName: weather.cityName),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 4.5.h,
                    ),
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _offset += details.primaryDelta!;
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  _offset = -50;
                });
                _weatherBloc.add(
                  RefreshWeather(cityName: weather.cityName),
                );
              },
              child: BlocListener<WeatherBloc, WeatherState>(
                bloc: _weatherBloc,
                listener: (context, state) {
                  if (state is WeatherError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${state.message} for City ${weather.cityName}. Please Enter Correct City Name',
                        ),
                      ),
                    );
                  }
                },
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  bloc: _weatherBloc,
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is WeatherLoaded) {
                      return _buildWeatherUi(state.weather);
                    }

                    return _buildWeatherUi(weather);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherUi(Weather weather) {
    return Center(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: _offset < 150 ? _offset : 150,
            child: Transform.rotate(
              angle: _offset / 50 < 5 ? _offset / 50 : 5,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.refresh,
                  size: 5.h,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.h),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
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
          ),
        ],
      ),
    );
  }
}
