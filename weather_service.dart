import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = '3be52228fc8e3b524196b3875baf3419';

  static Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }
}