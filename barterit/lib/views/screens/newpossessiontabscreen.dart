import 'dart:convert';
import 'dart:io';
import 'package:barterit/views/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
import 'package:intl/intl.dart';

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
  String selectedBarterType = "Cash";
  late DateTime _date_owned;
  bool _cash_checked = false;
  bool _goods_checked = false;
  bool _services_checked = false;
  bool _other_checked = false;
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

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _date_owned = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New possession"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.file(
                      widget.images[_selectedImageIndex]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.photo_library,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Possession name must be longer than 3"
                          : null,
                      onFieldSubmitted: (v) {},
                      controller: _possessionnameEditingController,
                      decoration: InputDecoration(
                        labelText: 'Possession Name',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.abc),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField(
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
                          child: Text(selectedType),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Type',
                        icon: Icon(Icons.type_specimen),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date Owned:',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Text(
                                "${_date_owned.day.toString().padLeft(2, '0')}/${_date_owned.month.toString().padLeft(2, '0')}/${_date_owned.year.toString().substring(2)}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    const SizedBox(height: 5),
                    const Text(
                      'Select Trade Options:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Cash"),
                            value: _cash_checked,
                            onChanged: (value) {
                              setState(() {
                                _cash_checked = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Goods"),
                            value: _goods_checked,
                            onChanged: (value) {
                              setState(() {
                                _goods_checked = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Services"),
                            value: _services_checked,
                            onChanged: (value) {
                              setState(() {
                                _services_checked = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Other"),
                            value: _other_checked,
                            onChanged: (value) {
                              setState(() {
                                _other_checked = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
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
    if (!_formKey.currentState!.validate() &&
        !_goods_checked &&
        !_cash_checked &&
        !_services_checked &&
        !_other_checked) {
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MainScreen(
                            user: widget.user,
                          )),
                );
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
    String date_owned = DateFormat('yyyy-MM-dd').format(_date_owned);
    bool cash_checked = _cash_checked;
    bool goods_checked = _goods_checked;
    bool services_checked = _services_checked;
    bool other_checked = _other_checked;
    List<String> base64Images = [];
    for (int i = 0; i < widget.images.length; i++) {
      String base64Image = base64Encode(widget.images[i]!.readAsBytesSync());
      base64Images.add(base64Image);
    }

    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/insert_possession.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "possession_name": possessionname,
          "possession_desc": possessiondesc,
          "possession_type": selectedType,
          "date_owned": date_owned,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "images": jsonEncode(base64Images),
          "cash_checked": cash_checked.toString(),
          "goods_checked": goods_checked.toString(),
          "services_checked": services_checked.toString(),
          "other_checked": other_checked.toString(),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date_owned,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date_owned) {
      setState(() {
        _date_owned = picked;
      });
    }
  }
}
