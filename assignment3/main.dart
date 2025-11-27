import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(NewWeatherApp());

class NewWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "New Stylish Weather App",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
      ),
      home: NewWeatherHome(),
    );
  }
}

class NewWeatherHome extends StatefulWidget {
  @override
  State<NewWeatherHome> createState() => _NewWeatherHomeState();
}

class _NewWeatherHomeState extends State<NewWeatherHome> {
  final TextEditingController cityController = TextEditingController(
    text: "Lahore",
  );

  Map<String, dynamic>? today;
  Map<String, dynamic>? nextday;
  String? error;
  bool loading = false;

  final String apiKey = "YOUR_API_KEY_HERE"; // 🔥 Replace this

  Future<void> getWeather(String city) async {
    setState(() {
      loading = true;
      error = null;
      today = null;
      nextday = null;
    });

    try {
      // Today Weather
      final url1 = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
      );
      final res1 = await http.get(url1);

      if (res1.statusCode != 200) {
        throw "Invalid city name";
      }

      final json1 = jsonDecode(res1.body);

      // Next Day Weather (forecast)
      final url2 = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
      );
      final res2 = await http.get(url2);

      if (res2.statusCode != 200) {
        throw "Forecast not available";
      }

      final json2 = jsonDecode(res2.body);

      // Choose one point 24 hours later (index 8 = 3-hour interval * 8 = 24 hours)
      final Map<String, dynamic> jsonNextDay = json2["list"][8];

      setState(() {
        today = json1;
        nextday = {
          "temp": jsonNextDay["main"]["temp"],
          "condition": jsonNextDay["weather"][0]["description"],
          "icon": jsonNextDay["weather"][0]["icon"],
        };
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Widget weatherCard(
    String title,
    String city,
    num temp,
    String condition,
    String icon,
  ) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.network(
              "https://openweathermap.org/img/wn/$icon@2x.png",
              width: 80,
              height: 80,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(city, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text(
                    "$temp°C",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(condition, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getWeather(cityController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f2027), Color(0xff203a43), Color(0xff2c5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        hintText: "Enter city...",
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (v) => getWeather(v),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => getWeather(cityController.text),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                      backgroundColor: Colors.blue,
                    ),
                    child: Icon(Icons.search, size: 28),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Error
              if (error != null)
                Text(error!, style: TextStyle(color: Colors.redAccent)),

              // Loader
              if (loading) CircularProgressIndicator(),

              SizedBox(height: 20),

              // Today's Weather
              if (today != null)
                weatherCard(
                  "Today",
                  today!["name"],
                  today!["main"]["temp"],
                  today!["weather"][0]["description"],
                  today!["weather"][0]["icon"],
                ),

              SizedBox(height: 20),

              // Next Day
              if (nextday != null)
                weatherCard(
                  "Next Day",
                  today!["name"],
                  nextday!["temp"],
                  nextday!["condition"],
                  nextday!["icon"],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
