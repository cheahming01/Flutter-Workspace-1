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

class PublishedPage extends StatefulWidget {
  final User user;

  const PublishedPage({super.key, required this.user});

  @override
  State<PublishedPage> createState() => _PublishedPageState();
}

class _PublishedPageState extends State<PublishedPage> {
  late double screenHeight, screenWidth;
  late int axiscount = 1;
  late List<Widget> tabchildren;
  String maintitle = "Published";
  List<Possession> possessionList = <Possession>[];

  @override
  void initState() {
    super.initState();
    loadPublishedPossessions();
    print("Published");
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

    return Scaffold(
      body: possessionList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1.4,
                    children: List.generate(
                      possessionList.length,
                      (index) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle cached image tap
                                      print("Cached image tapped");
                                    },
                                    child: CachedNetworkImage(
                                      height: screenWidth / 3,
                                      width: screenWidth / 3,
                                      imageUrl:
                                          "${MyConfig().SERVER}/barterit/assets/possessions/${possessionList[index].possessionId}/1.png",
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(Icons.swap_horiz),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("Logo image tapped");
                                          },
                                          child: Container(
                                            height: screenWidth / 3,
                                            width: screenWidth / 3,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            child: Image.asset(
                                              "assets/images/logo.png",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      possessionList[index]
                                          .possessionName
                                          .toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.more_horiz),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Modify your possession?'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Add additional content here if needed
                                                ],
                                              ),
                                              actions: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Possession
                                                              singlePossession =
                                                              Possession.fromJson(
                                                                  possessionList[
                                                                          index]
                                                                      .toJson());
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (content) =>
                                                                          EditPossessionScreen(
                                                                            user:
                                                                                widget.user,
                                                                            userPossession:
                                                                                singlePossession,
                                                                          )));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .green, // Set button color to light blue
                                                        ),
                                                        child:
                                                            const Text('Edit'),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // Handle delete option
                                                          Navigator.pop(
                                                              context);
                                                          onDeleteDialog(index);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .red, // Set button color to red
                                                        ),
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void loadPublishedPossessions() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {
          "userid": widget.user.id,
          "publish": true.toString(),
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
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/delete_possession.php"),
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
          loadPublishedPossessions();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
