import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather APP'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectLoc = "Changlun";
  List<String> locList = [
    "Changlun",
    "Jitra",
    "Alor Setar",
  ];
  String desc = "";
  double temp = 0.0;
  int hum = 0;
  String weather = "";

  loadWeather() async {
    var apiid = "8304ef5667dfec4d317385462d565d7d";
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$selectLoc&appid=$apiid&units=metric');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        temp = parsedJson['main']['temp'];
        hum = parsedJson['main']['humidity'];
        weather = parsedJson['weather'][0]['main'];
        desc =
            "The current weather in $selectLoc is $weather. The current temperature is $temp Celcius and humidity is $hum percent. ";
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Simple Weather",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        DropdownButton(
          itemHeight: 60,
          value: selectLoc,
          onChanged: (newValue) {
            setState(() {
              selectLoc = newValue.toString();
            });
          },
          items: locList.map((selectLoc) {
            return DropdownMenuItem(
              child: Text(
                selectLoc,
              ),
              value: selectLoc,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: loadWeather,
          child: const Text("Load Weather"),
        ),
        Text(
          desc,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}
