import 'package:skyguru/blocs/weather/weather_event.dart';
import 'package:skyguru/models/weather_model.dart';

abstract class WeatherState extends WeatherEvent {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
