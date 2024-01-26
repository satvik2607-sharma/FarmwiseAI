import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SecondScreen extends StatefulWidget {
  String name;
  String address;
  String dateOfBirth;

  String farmland;

  SecondScreen(this.name, this.address, this.dateOfBirth, this.farmland);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var Latitude;
  var Longitude;
  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location service is disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: 'Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permission denied forever');
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
      Latitude = currentPosition.latitude.toString();
      Longitude = currentPosition.longitude.toString();
    });
  }

  Position? position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Collected',
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              WeatherData(),
              Text(
                "Name: ${widget.name}",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                "Address: ${widget.address}",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                "Date of Birth ${widget.dateOfBirth}",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                "Gender: ",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                "Farmland Area(in Acres): ${widget.farmland}",
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                'latitude: ' + Latitude.toString(),
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Text(
                'longitude: ' + Longitude.toString(),
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              SizedBox(
                height: 35,
              ),
              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: const Text('Get coordinates')),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherData extends StatefulWidget {
  const WeatherData({super.key});

  @override
  State<WeatherData> createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  String currentTemperature = '';
  String currentCity = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final apiKey = '6c8adfaa1a0ca504b24a2dd88bdc2c6a';
    final latitude = position.latitude;
    final longitude = position.longitude;

    final weatherApiUrl =
        'https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={6c8adfaa1a0ca504b24a2dd88bdc2c6a}';
    final response = await http.get(Uri.parse(weatherApiUrl));

    if (response.statusCode == 200) {
      final weatherData = jsonDecode(response.body);
      setState(() {
        currentTemperature =
            'Current Temperature: ${weatherData['main']['temp']} C';
        currentCity = 'Current City: ${weatherData['name']}';
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            currentTemperature,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            currentCity,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
