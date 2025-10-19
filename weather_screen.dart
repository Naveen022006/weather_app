import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  Future<Weather>? _weatherFuture;
  String _currentCity = '';

  void _fetchWeather() {
    if (_cityController.text.trim().isEmpty) return;
    
    setState(() {
      _currentCity = _cityController.text.trim();
      _weatherFuture = WeatherService.fetchWeather(_currentCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter city name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _fetchWeather(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildWeatherDisplay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay() {
    if (_weatherFuture == null) {
      return const Center(
        child: Text('Enter a city name to get weather information'),
      );
    }

    return FutureBuilder<Weather>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return _buildWeatherCard(weather);
        }

        return const Center(child: Text('No data available'));
      },
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
              width: 60,
              height: 60,
            ),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Feels like: ${weather.feelsLike.round()}°C'),
                Text('Humidity: ${weather.humidity}%'),
                Text('Wind: ${weather.windSpeed} m/s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}