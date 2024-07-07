import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String cityName;
  const FetchWeather({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

class RefreshWeather extends WeatherEvent {
  final String cityName;

  const RefreshWeather({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

class ResetWeather extends WeatherEvent {}