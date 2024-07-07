import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyguru/blocs/weather/weather_event.dart';
import 'package:skyguru/blocs/weather/weather_state.dart';
import 'package:skyguru/repositories/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<FetchWeather>(_fetchWeather);
    on<RefreshWeather>(_refreshWeather);
    on<ResetWeather>(_resetWeather);
  }

  void _fetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeather(city: event.cityName);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(const WeatherError("Could not fetch weather"));
    }
  }

  void _refreshWeather(RefreshWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeather(city: event.cityName);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(const WeatherError('Could not fetch'));
    }
  }

  void _resetWeather(ResetWeather event, Emitter<WeatherState> emit) {
    emit(WeatherInitial());
  }
}
