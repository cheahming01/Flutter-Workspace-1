import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text('Country Info'),
      ),
      body: const MainApp(),
    ),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  
  final TextEditingController uCountry = TextEditingController();
  String _message = '';
  
  void _sendMessage() {
    if (uCountry.text.isEmpty) {
      setState(() {
        _message = 'Please enter a country name';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_message),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      setState(() {
        _message = uCountry.text;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ZoomedBackgroundPage(
            countryName: _message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/earth.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: uCountry,
              decoration: const InputDecoration(
                hintText: 'Country name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (_sendMessage),
            child: const Text('Search'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              backgroundColor: Colors.grey[700],
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ZoomedBackgroundPage extends StatefulWidget {
  final String countryName;

  const ZoomedBackgroundPage({required this.countryName, Key? key})
      : super(key: key);

  @override
  State<ZoomedBackgroundPage> createState() => _ZoomedBackgroundPageState();
}

class _ZoomedBackgroundPageState extends State<ZoomedBackgroundPage> {
  var desc = "\nNo Data";
  var fullDescExpanded = false;
  var countryName = '';
  var currencyName = '';
  var currencyCode = '';
  var countryCapital = '';
  var countryIso = '';
  var countryRegion = '';
  ImageProvider countryFlag = const NetworkImage('');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/earth.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: countryFlag,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Text('');
                  },
                ),
                Text(
                  '"${widget.countryName}"',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: Text(
                    desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  secondChild: Text(
                    desc,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  crossFadeState: fullDescExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
                fullDescExpanded
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            fullDescExpanded = true;
                          });
                        },
                        child: const Text(
                          'Expand',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                fullDescExpanded
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            fullDescExpanded = false;
                          });
                        },
                        child: const Text(
                          'Collapse',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getCountryInfo() async {
    String country = widget.countryName;
    http.Response response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/country?name=$country'),
      headers: {
        'X-Api-Key': 'yVlcH/OrWZD64h0GVdqYMw==39SD9Uv27UV9r2Kr',
      },
    );


    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      if (parsedJson.isNotEmpty) {
        countryName = parsedJson[0]['name'];
        currencyName = parsedJson[0]['currency']['name'];
        currencyCode = parsedJson[0]['currency']['code'];
        countryCapital = parsedJson[0]['capital'];
        countryIso = parsedJson[0]['iso2'];
        countryRegion = parsedJson[0]['region'];
        setState(() {
          desc =
              "\nCapital: $countryCapital, $countryRegion. \n Official Currenncy: $currencyName($currencyCode)";
          countryFlag =
              NetworkImage('https://flagsapi.com/$countryIso/shiny/64.png');
        });
      } else {
        setState(() {
          desc = "No Country Record!";
          countryFlag = const NetworkImage(
              'https://icon-library.com/images/no-data-icon/no-data-icon-5.jpg');
        });
      }
    } else {
      setState(() {
        desc = "Failed to load data";
        countryFlag = const NetworkImage(
            'https://icon-library.com/images/no-data-icon/no-data-icon-5.jpg');
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getCountryInfo();
  } 
}
