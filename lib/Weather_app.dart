import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _controller.forward();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WeatherHomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wb_sunny, size: 100, color: Colors.orangeAccent),
              SizedBox(height: 20),
              Text(
                'Weather App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String? _city;
  String _weather = '';
  String _temperature = '';
  List<dynamic> _forecast = [];
  bool _loading = true;
  final TextEditingController _cityController = TextEditingController();
  final List<String> _citySuggestions = [
    'Multan',
    'Lahore',
    'Karachi',
    'Islamabad',
    'Faisalabad',
  ];

  final String _apiKey = '7fbff4f304962802310bb36986556e1a';

  @override
  void initState() {
    super.initState();
    _loadSavedWeather();
    _getCurrentLocation();
  }

  Future<void> _loadSavedWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _city = prefs.getString('city');
      _weather = prefs.getString('weather') ?? '';
      _temperature = prefs.getString('temperature') ?? '';
      _forecast = jsonDecode(prefs.getString('forecast') ?? '[]');
      _loading = false;
    });
  }

  Future<void> _saveWeather(
    String city,
    String weather,
    String temp,
    List forecast,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);
    prefs.setString('weather', weather);
    prefs.setString('temperature', temp);
    prefs.setString('forecast', jsonEncode(forecast));
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location disabled');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 5),
      );

      await _fetchWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Location error: $e');
      await _fetchWeatherByCity('Multan,PK');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _fetchWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final weather = data['list'][0]['weather'][0]['main'];
      final temp = data['list'][0]['main']['temp'].toString();
      final forecast = data['list'].take(5).toList();

      setState(() {
        _city = data['city']['name'];
        _weather = weather;
        _temperature = temp;
        _forecast = forecast;
      });

      await _saveWeather(_city ?? 'Unknown', weather, temp, forecast);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load weather data.')));
    }
  }

  Future<void> _fetchWeatherByCity(String city) async {
    city = city.trim();
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric',
    );
    debugPrint('Fetching weather for: $city');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final weather = data['list'][0]['weather'][0]['main'];
      final temp = data['list'][0]['main']['temp'].toString();
      final forecast = data['list'].take(5).toList();

      if (mounted) {
        setState(() {
          _city = data['city']['name'];
          _weather = weather;
          _temperature = temp;
          _forecast = forecast;
        });
      }

      await _saveWeather(city, weather, temp, forecast);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('City not found or API error.')));
      }
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Icons.beach_access;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.wb_sunny;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  String _getWeekDay(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat.EEEE().format(date); // e.g., Monday, Tuesday
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade300,
                    Colors.lightBlueAccent.shade100,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _citySuggestions.where(
                            (String option) => option.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ),
                          );
                        },
                        onSelected: (String selection) {
                          _cityController.text = selection;
                          _fetchWeatherByCity(selection);
                        },
                        fieldViewBuilder:
                            (
                              context,
                              controller,
                              focusNode,
                              onEditingComplete,
                            ) {
                              _cityController.text = controller.text;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                onEditingComplete: onEditingComplete,
                                decoration: InputDecoration(
                                  hintText: 'Enter city name',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () => _fetchWeatherByCity(
                                      controller.text.trim(),
                                    ),
                                  ),
                                ),
                              );
                            },
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              _getWeatherIcon(_weather),
                              size: 80,
                              color: Colors.yellow.shade800,
                            ),
                            SizedBox(height: 10),
                            Text(
                              _city ?? '',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_temperature°C',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(_weather, style: TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '5-Day Forecast',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _forecast.length,
                          itemBuilder: (context, index) {
                            final item = _forecast[index];
                            final date = item['dt_txt'];
                            final main = item['weather'][0]['main'];
                            final temp = item['main']['temp'].toString();
                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: Icon(
                                  _getWeatherIcon(main),
                                  color: Colors.blue,
                                ),
                                title: Text(_getWeekDay(date)),
                                subtitle: Text('$main - $temp°C'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
