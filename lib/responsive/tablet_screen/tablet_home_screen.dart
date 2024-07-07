import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyguru/repositories/weather_repository.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_weather_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_weather_screen.dart';
import '../../blocs/weather/weather_bloc.dart';
import '../../blocs/weather/weather_event.dart';
import '../../blocs/weather/weather_state.dart';

class TabletHomeScreen extends StatefulWidget {
  const TabletHomeScreen({super.key});

  @override
  State<TabletHomeScreen> createState() => _TabletHomeScreenState();
}

class _TabletHomeScreenState extends State<TabletHomeScreen> {
  late TextEditingController _cityController;
  late WeatherBloc _weatherBloc;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _weatherBloc = WeatherBloc(weatherRepository: WeatherRepository());
  }

  @override
  void dispose() {
    _cityController.dispose();
    _weatherBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: BlocListener<WeatherBloc, WeatherState>(
        bloc: _weatherBloc,
        listener: (context, state) {
          if (state is WeatherLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ResponsiveLayout(
                  mobileScreen: MobileWeatherScreen(),
                  tabletScreen: TabletWeatherScreen(),
                ),
              ),
            );
          } else if (state is WeatherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to fetch weather: ${state.message}'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _submitCityName(_cityController.text);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitCityName(_cityController.text);
                },
                child: const Text('Get Weather'),
              ),
              const SizedBox(height: 20),
              BlocBuilder<WeatherBloc, WeatherState>(
                bloc: _weatherBloc,
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitCityName(String cityName) {
    if (cityName.isNotEmpty) {
      _weatherBloc.add(FetchWeather(cityName: cityName));
    }
  }
}
