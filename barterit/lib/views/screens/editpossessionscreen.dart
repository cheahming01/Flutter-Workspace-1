import 'dart:convert';
import 'package:barterit/views/screens/mainscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
import 'package:intl/intl.dart';

import '../../models/possession.dart';

class EditPossessionScreen extends StatefulWidget {
  final User user;
  final Possession userPossession;

  const EditPossessionScreen(
      {Key? key, required this.user, required this.userPossession});

  @override
  State<EditPossessionScreen> createState() => _EditPossessionScreenState();
}

class _EditPossessionScreenState extends State<EditPossessionScreen> {
  // File? _image;
  // var pathAsset = "assets/images/logo.png";
  String selectedBarterType = "Cash";
  late DateTime _date_owned;
  late bool _cash_checked;
  late bool _goods_checked;
  late bool _services_checked;
  late bool _other_checked;
  bool _publish = false;
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

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _possessionnameEditingController.text =
        widget.userPossession.possessionName.toString();
    _possessiondescEditingController.text =
        widget.userPossession.possessionDesc.toString();
    _prstateEditingController.text = widget.userPossession.state.toString();
    _prlocalEditingController.text = widget.userPossession.locality.toString();
    selectedType = widget.userPossession.possessionType.toString();
    if (widget.userPossession.dateOwned != null) {
      _date_owned = DateTime.parse(widget.userPossession.dateOwned.toString());
    } else {
      _date_owned = DateTime.now();
    }
    _cash_checked = widget.userPossession.cash_checked ?? false;
    _goods_checked = widget.userPossession.goods_checked ?? false;
    _services_checked = widget.userPossession.services_checked ?? false;
    _other_checked = widget.userPossession.other_checked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update possession"),
      ),
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
                    child: CachedNetworkImage(
                      width: screenWidth,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${MyConfig().SERVER}/barterit/assets/possessions/${widget.userPossession.possessionId}/1.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                                updateDialog();
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
                                updateDialog();
                                setState(() {
                                  _publish = true;
                                });
                                print("Publish: $_publish");
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

  void updateDialog() {
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
            "Update your possession?",
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
                updatePossession();
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
                setState(() {
                  _publish = false;
                });
                print("Publish: $_publish");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updatePossession() {
    String possessionname = _possessionnameEditingController.text;
    String possessiondesc = _possessiondescEditingController.text;
    String date_owned = DateFormat('yyyy-MM-dd').format(_date_owned);
    bool cash_checked = _cash_checked;
    bool goods_checked = _goods_checked;
    bool services_checked = _services_checked;
    bool other_checked = _other_checked;
    bool publish = _publish;
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/update_possession.php"),
        body: {
          "possession_id": widget.userPossession.possessionId,
          "possession_name": possessionname,
          "possession_desc": possessiondesc,
          "possession_type": selectedType,
          "date_owned": date_owned,
          "cash_checked": cash_checked.toString(),
          "goods_checked": goods_checked.toString(),
          "services_checked": services_checked.toString(),
          "other_checked": other_checked.toString(),
          "publish": publish.toString(),
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  user: widget.user,
                )),
      );
    });
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
