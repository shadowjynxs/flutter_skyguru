import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:skyguru/models/weather_model.dart';

class WeatherRepository {
  static const String _apiKey = "0b3947e77d701c8b7a6f1c20ac1b54bd";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Weather> getWeather({required String city}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?q=$city&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJSON(json.decode(response.body));
    } else {
      throw Exception('Failed to load Weather');
    }
  }
}
