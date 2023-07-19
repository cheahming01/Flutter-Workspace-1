import 'dart:convert';
import 'dart:developer';
import 'package:barterit/views/screens/buyerdetailscreen.dart';
import 'package:barterit/views/screens/editpossessionscreen.dart';
import 'package:barterit/views/screens/reqoption.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/possession.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
//import 'editpossessionscreen.dart';

class PublishedPage extends StatefulWidget {
  final User user;

  const PublishedPage({Key? key, required this.user}) : super(key: key);

  @override
  State<PublishedPage> createState() => _PublishedPageState();
}

class _PublishedPageState extends State<PublishedPage> {
  late double screenHeight, screenWidth;
  late int axiscount = 1;
  String maintitle = "Published";
  List<Possession> possessionList = <Possession>[];
  late ScrollController _scrollController;
  bool isLoading = false;
  bool reachedEndOfList = false;
  int curPage = 1;
  int numPages = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    loadPublishedPossessions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      loadMorePossessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: possessionList.isEmpty
          ? const Center(
              child: Text("Try to publish your own possession~"),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    controller: _scrollController,
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1.4,
                    children: [
                      ...possessionList.map((possession) => Container(
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
                                        Possession singlePossession =
                                            Possession.fromJson(
                                                possession.toJson());
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BuyerDetailScreen(
                                              user: widget.user,
                                              userPossession: singlePossession,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                        height: screenWidth / 3,
                                        width: screenWidth / 3,
                                        imageUrl:
                                            "${MyConfig().SERVER}/barterit/assets/possessions/${possession.possessionId}/1.png",
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
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.4,
                                                    child: ReqOption(),
                                                  );
                                                },
                                              );
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: screenWidth / 3,
                                                  width: screenWidth / 3,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Image.asset(
                                                    "assets/images/barterOption.jpg",
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 10,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (possession
                                                              .cash_checked
                                                              .toString() ==
                                                          "true")
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      if (possession
                                                              .goods_checked
                                                              .toString() ==
                                                          "true")
                                                        SizedBox(width: 10),
                                                      if (possession
                                                              .goods_checked
                                                              .toString() ==
                                                          "true")
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.yellow,
                                                          ),
                                                        ),
                                                      if (possession
                                                              .services_checked
                                                              .toString() ==
                                                          "true")
                                                        SizedBox(width: 10),
                                                      if (possession
                                                              .services_checked
                                                              .toString() ==
                                                          "true")
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                        ),
                                                      if (possession
                                                              .other_checked
                                                              .toString() ==
                                                          "true")
                                                        SizedBox(width: 10),
                                                      if (possession
                                                              .other_checked
                                                              .toString() ==
                                                          "true")
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                        possession.possessionName.toString(),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                    possession
                                                                        .toJson());
                                                            await Navigator
                                                                .push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (content) =>
                                                                        EditPossessionScreen(
                                                                  user: widget
                                                                      .user,
                                                                  userPossession:
                                                                      singlePossession,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.green,
                                                            // Set button color to light blue
                                                          ),
                                                          child: const Text(
                                                              'Edit'),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            // Handle delete option
                                                            Navigator.pop(
                                                                context);
                                                            onDeleteDialog(
                                                                possession);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                            // Set button color to red
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
                          )),
                      if (reachedEndOfList)
                        Center(
                          child: Text(
                            "You have reached the end of the list",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void loadPublishedPossessions() {
    setState(() {
      isLoading = true;
    });

    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
      body: {
        "userid": widget.user.id,
        "publish": true.toString(),
        "available": true.toString(),
      },
    ).then((response) {
      log(response.body);
      possessionList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numPages = int.parse(jsondata['numofpage']);
          var extractdata = jsondata['data'];
          extractdata['possessions'].forEach((v) {
            possessionList.add(Possession.fromJson(v));
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void onDeleteDialog(Possession possession) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text("Delete ${possession.possessionName}?"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                deletePossession(possession);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deletePossession(Possession possession) {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/delete_possession.php"),
      body: {
        "userid": widget.user.id,
        "possessionid": possession.possessionId,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Delete Success")),
          );
          loadPublishedPossessions();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed")),
          );
        }
      }
    });
  }

  void loadMorePossessions() {
    if (!isLoading && !reachedEndOfList && curPage < numPages) {
      setState(() {
        isLoading = true;
        curPage++;
      });

      http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {
          "userid": widget.user.id,
          "publish": true.toString(),
          "pageno": curPage.toString(),
        },
      ).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            var extractdata = jsondata['data'];
            extractdata['possessions'].forEach((v) {
              possessionList.add(Possession.fromJson(v));
            });
          }
        }

        setState(() {
          isLoading = false;
          if (curPage == numPages) {
            reachedEndOfList = true;
          }
        });
      });
    }
  }
}
