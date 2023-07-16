import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherAgroAdvisorApp());
}

class WeatherAgroAdvisorApp extends StatefulWidget {
  @override
  _WeatherAgroAdvisorAppState createState() => _WeatherAgroAdvisorAppState();
}

class _WeatherAgroAdvisorAppState extends State<WeatherAgroAdvisorApp> {
  final String apiBaseUrl = 'http://api.weatherapi.com/v1/current.json';
  final String apiKey = '8978778ae5534ff0af5203259231407'; // Replace with your actual API key
  String location = '';

  String temperature = '';
  String humidity = '';
  String windSpeed = '';
  String condition = '';
  String advice = '';

  Future<void> getWeatherData() async {
    final response = await http.get(Uri.parse('$apiBaseUrl?key=$apiKey&q=$location'));
    final data = jsonDecode(response.body);

    setState(() {
      temperature = data['current']['temp_c'].toString();
      humidity = data['current']['humidity'].toString();
      windSpeed = data['current']['wind_kph'].toString();
      condition = data['current']['condition']['text'].toString();

      // Perform agro advice based on weather conditions
      advice = '';
      if (double.parse(temperature) > 30) {
        advice += "It's hot. Make sure to provide adequate water to your crops.\n";
      }
      if (int.parse(humidity) > 80) {
        advice += "High humidity can lead to fungal diseases. Take necessary precautions.\n";
      }
      if (double.parse(windSpeed) > 40) {
        advice += "Strong winds may damage your crops. Secure them if necessary.\n";
      }
      if (condition.toLowerCase().contains('rain')) {
        advice += "Rain is expected. Delay irrigation if possible.\n";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather Agro Advisor'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) {
                  location = value;
                },
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  getWeatherData();
                },
                child: Text('Get Weather Data'),
              ),
              SizedBox(height: 16.0),
              Text('Temperature: $temperature'),
              Text('Humidity: $humidity'),
              Text('Wind Speed: $windSpeed'),
              Text('Condition: $condition'),
              SizedBox(height: 16.0),
              Text(
                'Agro Advice:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(advice),
            ],
          ),
        ),
      ),
    );
  }
}
