// ignore_for_file: public_member_api_docs, sort_constructors_first
class Weather {
  final String cityName;
  final double temperature;
  final String weatherCondition;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherCondition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
  });

  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble() - 273.15,
      weatherCondition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      feelsLike: json['main']['feels_like'] - 273.15,
      tempMin: json['main']['temp_min'] - 273.15,
      tempMax: json['main']['temp_max'] - 273.15,

    );
  }
}
