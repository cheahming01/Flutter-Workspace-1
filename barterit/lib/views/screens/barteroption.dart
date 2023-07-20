// BarterOption.dart
import 'dart:convert';
import 'dart:developer';
import 'package:barterit/views/screens/buyerdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/possession.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

class BarterOption extends StatefulWidget {
  final User user;
  final String ownerPossId;

  const BarterOption({Key? key, required this.user, required this.ownerPossId})
      : super(key: key);
  @override
  State<BarterOption> createState() => _BarterOptionState();
}

class _BarterOptionState extends State<BarterOption> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Storage";
  List<Possession> possessionList = <Possession>[];
  final _cashInputController = TextEditingController();
  late int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadStoragePossessions();
    print("Storage");
  }

  @override
  void dispose() {
    // Set the flag to false during disposal
    _cashInputController.dispose();
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
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Row(
                children: [
                  SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              '\$',
                              style: TextStyle(color: Colors.green),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: TextFormField(
                                controller:
                                    _cashInputController, // Assign the controller
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  hintStyle: TextStyle(color: Colors.green),
                                ),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String cashInput = _cashInputController.text;
                      if (selectedIndex != -1) {
                        String? possessionId =
                            possessionList[selectedIndex].possessionId;
                        if (possessionId != null) {
                          int parsedPossessionId = int.parse(possessionId);
                          print("possessionId: $parsedPossessionId");
                        }
                        reqTrade(cashInput, possessionId!);
                        Navigator.of(context).pop();
                      } else {
                        // No possession selected
                        // Show an error message or handle the case
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select a possession")));
                      }
                    },
                    child: const Text('Confirm Trade'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: possessionList.isEmpty
                ? const Center(
                    child: Text("No Data"),
                  )
                : SingleChildScrollView(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: axiscount,
                      children: List.generate(
                        possessionList.length,
                        (index) {
                          return Stack(
                            children: [
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (selectedIndex == index) {
                                        // Deselect if already selected
                                        selectedIndex = -1;
                                      } else {
                                        // Select the possession
                                        selectedIndex = index;
                                      }
                                    });
                                  },
                                  onLongPress: () async {
                                    Possession singlepossession =
                                        Possession.fromJson(
                                            possessionList[index].toJson());
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            BuyerDetailScreen(
                                          user: widget.user,
                                          userPossession: singlepossession,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "${MyConfig().SERVER}/barterit/assets/possessions/${possessionList[index].possessionId}/1.png",
                                          placeholder: (context, url) =>
                                              const LinearProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          possessionList[index]
                                              .possessionName
                                              .toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedIndex == index) {
                                        // Deselect if already selected
                                        selectedIndex = -1;
                                      } else {
                                        // Select the possession
                                        selectedIndex = index;
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: selectedIndex == index
                                        ? Colors.blue
                                        : Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void reqTrade(String cashInput, String userPossId) async {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/insert_request.php"),
      body: {
        "userId": widget.user.id,
        "cashInput": cashInput,
        "ownerPossId": widget.ownerPossId,
        "userPossId": userPossId,
        "status": "requesting",
      },
    ).then((response) {
      log(response.body);
      // Handle the response from the PHP script
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Request Sent")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to request")));
        // Error storing request
        // Handle the error or show an error message
      }
    });
  }

  // void updatePossessionReqId(int reqId, int possessionId) {
  //   // Prepare the JSON data

  //   http.post(
  //     Uri.parse("${MyConfig().SERVER}/barterit/php/update_req_id.php"),
  //     body: {
  //       "possessionId": possessionId.toString(),
  //       "req_id": reqId.toString(),
  //     },
  //   ).then((response) {
  //     log(response.body);
  //     // Handle the response from the PHP script
  //     var data = jsonDecode(response.body);
  //     if (data['status'] == "success") {
  //       print("success");
  //       // Possession updated successfully
  //     } else {
  //       print("fail");
  //       // Error updating possession
  //     }
  //   });
  // }

  void loadStoragePossessions() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {
          "userid": widget.user.id,
          "publish": false.toString(),
          "available": false.toString(),
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
}
