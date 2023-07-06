// StoragePage.dart
import 'dart:convert';
import 'dart:developer';
import 'package:barterit/views/screens/editpossessionscreen.dart';
import 'package:barterit/views/screens/imagepickerpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/possession.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
//import 'editpossessionscreen.dart';

class StoragePage extends StatefulWidget {
  final User user;

  const StoragePage({super.key, required this.user});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Storage";
  List<Possession> possessionList = <Possession>[];

  @override
  void initState() {
    super.initState();
    loadStoragePossessions();
    print("Storage");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      body: possessionList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        possessionList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Possession singlepossession =
                                    Possession.fromJson(
                                        possessionList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            EditPossessionScreen(
                                              user: widget.user,
                                              userPossession: singlepossession,
                                            )));
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth / 2.5,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit/assets/possessions/${possessionList[index].possessionId}/1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  possessionList[index]
                                      .possessionName
                                      .toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ]),
                            ),
                          );
                        },
                      )))
            ]),
    );
  }

  void loadStoragePossessions() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {
          "userid": widget.user.id,
          "publish": false.toString(),
        }).then((response) {
      //print(response.body);
      log(response.body);
      possessionList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['possessions'].forEach((v) {
            possessionList.add(Possession.fromJson(v));
          });
          print(possessionList[0].possessionName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${possessionList[index].possessionName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deletepossession(index);
                Navigator.of(context).pop();
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

  void deletepossession(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/delete_possession.php"),
        body: {
          "userid": widget.user.id,
          "possessionid": possessionList[index].possessionId
        }).then((response) {
      print(response.body);
      //possessionList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadStoragePossessions();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
