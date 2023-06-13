import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

class NewPossessionTabScreen extends StatefulWidget {
  final User user;
  final List<File?> images;

  const NewPossessionTabScreen(
      {super.key, required this.user, required this.images});

  @override
  State<NewPossessionTabScreen> createState() => _NewPossessionTabScreenState();
}

class _NewPossessionTabScreenState extends State<NewPossessionTabScreen> {
  // File? _image;
  // var pathAsset = "assets/images/logo.png";
  int _selectedImageIndex = 0;
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _possessionnameEditingController =
      TextEditingController();
  final TextEditingController _possessiondescEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _barterDescEditingController =
      TextEditingController();
  String selectedType = "Goods";
  List<String> possessionlist = [
    "Goods",
    "Services",
    "Other",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  String selectedBarterType = "Cash";
  final TextEditingController _specificItemEditingController =
      TextEditingController();
  List<String> barterlist = ["Cash", "Goods", "Services", "Other"];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _specificItemEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    int _dotCount = widget.images.length;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New possession"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(children: [
        Column(
          children: [
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx > 0) {
                  // Swipe from left to right
                  setState(() {
                    _selectedImageIndex = (_selectedImageIndex - 1)
                        .clamp(0, widget.images.length - 1);
                    _dotCount = widget.images.length;
                  });
                } else if (details.velocity.pixelsPerSecond.dx < 0) {
                  // Swipe from right to left
                  setState(() {
                    _selectedImageIndex = (_selectedImageIndex + 1)
                        .clamp(0, widget.images.length - 1);
                    _dotCount = widget.images.length;
                  });
                }
              },
              child: Stack(
                children: [
                  Image.file(
                    widget.images[_selectedImageIndex]!,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_dotCount, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedImageIndex == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            // Add code to display the remaining images here
          ],
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 60,
                          child: DropdownButton(
                            //sorting dropdownoption
                            // Not necessary for Option 1
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: possessionlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Possession name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {},
                              controller: _possessionnameEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Possession Name',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.abc),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        )
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Possession description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _possessiondescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Possession Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _prstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: selectedBarterType == 'Cash',
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked!) {
                                selectedBarterType = 'Cash';
                                _barterDescEditingController.text =
                                    'Cash'; // Set default description
                              } else {
                                selectedBarterType = '';
                                _barterDescEditingController.text = '';
                              }
                            });
                          },
                        ),
                        const Text('Cash'),
                        Checkbox(
                          value: selectedBarterType == 'Goods',
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked!) {
                                selectedBarterType = 'Goods';
                              } else {
                                selectedBarterType = '';
                              }
                              _barterDescEditingController.text = '';
                            });
                          },
                        ),
                        const Text('Goods'),
                        Checkbox(
                          value: selectedBarterType == 'Services',
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked!) {
                                selectedBarterType = 'Services';
                              } else {
                                selectedBarterType = '';
                              }
                              _barterDescEditingController.text = '';
                            });
                          },
                        ),
                        const Text('Services'),
                        Checkbox(
                          value: selectedBarterType == 'Others',
                          onChanged: (isChecked) {
                            setState(() {
                              if (isChecked!) {
                                selectedBarterType = 'Others';
                              } else {
                                selectedBarterType = '';
                              }
                            });
                          },
                        ),
                        const Text('Others'),
                      ],
                    ),
                    if (selectedBarterType != 'Cash') ...[
                      Expanded(
                        child: TextFormField(
                          controller: _barterDescEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.description),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: screenWidth / 2.4,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                insertDialog();
                              },
                              child: const Text("Store"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            width: screenWidth / 2.4,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                insertDialog();
                              },
                              child: const Text("Publish"),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your possession?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertPossession();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertPossession() {
    String possessionname = _possessionnameEditingController.text;
    String possessiondesc = _possessiondescEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    List<String> base64Images = [];
    for (int i = 0; i < widget.images.length; i++) {
      String base64Image = base64Encode(widget.images[i]!.readAsBytesSync());
      base64Images.add(base64Image);
    }

    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/insert_possession.php"),
        body: {
          "userid": widget.user.id.toString(),
          "possessionname": possessionname,
          "possessiondesc": possessiondesc,
          "type": selectedType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "images": jsonEncode(base64Images),
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
