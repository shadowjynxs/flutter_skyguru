// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/blocs/weather/weather_bloc.dart';
import 'package:skyguru/blocs/weather/weather_event.dart';
import 'package:skyguru/blocs/weather/weather_state.dart';
import 'package:skyguru/repositories/weather_repository.dart';
import '../../models/weather_model.dart';
import 'package:intl/intl.dart';

class TabletWeatherScreen extends StatefulWidget {
  const TabletWeatherScreen({super.key});

  @override
  State<TabletWeatherScreen> createState() => _TabletWeatherScreenState();
}

class _TabletWeatherScreenState extends State<TabletWeatherScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = false;

  final WeatherBloc _weatherBloc = WeatherBloc(weatherRepository: WeatherRepository());
  double _offset = -50.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() {
          _isLoading = false;
        });
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _weatherBloc.close();
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      _controller.forward();
    }
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
                  fontSize: 20.sp,
                ),
              ),
              centerTitle: true,
              leading: Icon(
                Icons.menu,
                color: Colors.white,
                size: 10.w,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    _handleRefresh();
                    _weatherBloc.add(
                      RefreshWeather(cityName: weather.cityName),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: RotationTransition(
                      turns: _animation,
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 4.5.h,
                      ),
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
                double temp = _offset;
                setState(() {
                  _offset = -50;
                });
                if (temp >= 300) {
                  _weatherBloc.add(
                    RefreshWeather(cityName: weather.cityName),
                  );
                }
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
                  } else if (state is WeatherLoaded) {
                    setState(() {
                      _isLoading = false;
                    });
                    _controller.reset();
                    _controller.stop();
                  }
                },
                child: BlocBuilder<WeatherBloc, WeatherState>(
                  bloc: _weatherBloc,
                  builder: (context, state) {
                    if (state is WeatherLoading) {
                      return Center(
                        child: SpinKitThreeBounce(
                          color: Colors.orange,
                        ),
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
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 10.h,
                  ),
                  child: Container(

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.blue.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText(
                                  weather.cityName,
                                  14.sp,
                                  FontWeight.w400,
                                ),
                                customText(
                                  DateFormat("EEEE, d MMMM", "en_US").format(DateTime.now()),
                                  14.sp,
                                  FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  'http://openweathermap.org/img/w/${weather.icon}.png',
                                  filterQuality: FilterQuality.high,
                                  scale: 0.4,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 9.w),
                                  child: Column(
                                    children: [
                                      customText(
                                        weather.weatherCondition,
                                        18.sp,
                                        FontWeight.w400,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          text: weather.temperature.toStringAsFixed(0),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 48.sp,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '°C',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    CupertinoIcons.drop,
                                    color: Colors.white,
                                    size: 10.w,
                                  ),
                                  customText(
                                    'HUMIDITY',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                  customText(
                                    '${weather.humidity}%',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    CupertinoIcons.wind,
                                    color: Colors.white,
                                    size: 10.w,
                                  ),
                                  customText(
                                    'WIND',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                  customText(
                                    '${weather.windSpeed} km/h',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    CupertinoIcons.thermometer,
                                    color: Colors.white,
                                    size: 10.w,
                                  ),
                                  customText(
                                    'FEELS LIKE',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                  customText(
                                    '${weather.windSpeed} km/h',
                                    14.sp,
                                    FontWeight.w400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customText(
    String text,
    double size,
    FontWeight weight,
  ) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: Colors.white,
      ),
    );
  }
}
