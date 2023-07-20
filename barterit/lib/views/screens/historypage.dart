import 'dart:convert';
import 'dart:developer';
import 'package:barterit/models/request.dart';
import 'package:barterit/views/screens/buyerdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
//import 'editpossessionscreen.dart';

class HistoryPage extends StatefulWidget {
  final User user;

  const HistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late double screenHeight, screenWidth;
  late int axiscount = 1;
  String maintitle = "Published";
  List<Request> requestList = <Request>[];
  late ScrollController _scrollController;
  bool isLoading = false;
  bool reachedEndOfList = false;
  int curPage = 1;
  int numPages = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    loadRequests();
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
      loadMoreRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: requestList.isEmpty
          ? const Center(
              child: Text("Try to request for bartering!"),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    controller: _scrollController,
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1.9,
                    children: [
                      ...requestList.map((request) => Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      request.ownerUsername.toString() ==
                                              widget.user.name
                                          ? "You"
                                          : request.ownerUsername.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      request.userUsername.toString() ==
                                              widget.user.name
                                          ? "You"
                                          : request.userUsername.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap logic
                                      },
                                      child: CachedNetworkImage(
                                        height: screenWidth / 3,
                                        width: screenWidth / 3,
                                        imageUrl:
                                            "${MyConfig().SERVER}/barterit/assets/possessions/${request.ownerPossId}/1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.swap_horiz),
                                    ),
                                    Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: CachedNetworkImage(
                                            alignment: Alignment.centerRight,
                                            height: screenWidth / 3,
                                            width: screenWidth / 3,
                                            imageUrl:
                                                "${MyConfig().SERVER}/barterit/assets/possessions/${request.userPossId}/1.png",
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            color: Colors.black54,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '\$ ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    request.cashInput
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                        request.ownerPossName.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        request.userPossName.toString(),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: request.status == "Rejected" ||
                                              request.status == "Completed"
                                          ? null
                                          : () {
                                              if (request.status ==
                                                  "requesting") {
                                                if (widget.user.name ==
                                                    request.ownerUsername) {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Accept or Reject Request'),
                                                        content: Text(
                                                            'Would you like to accept or reject the request?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                request.status =
                                                                    "Completed";
                                                              });
                                                              updateRequest(
                                                                  request);
                                                              // Handle accept logic
                                                              Navigator.pop(
                                                                  context); // Close the dialog
                                                            },
                                                            child:
                                                                Text('Accept'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                request.status =
                                                                    "Rejected";
                                                              });
                                                              updateRequestStatus(
                                                                  request
                                                                      .reqId!,
                                                                  "Rejected");
                                                              Navigator.pop(
                                                                  context); // Close the dialog
                                                            },
                                                            child:
                                                                Text('Reject'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Cancel Request'),
                                                      content: Text(
                                                          'Are you sure you want to cancel the request?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            deleteRequest(
                                                                request);
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          child: Text('Yes'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                          },
                                                          child: Text('No'),
                                                        ),
                                                      ],
                                                    );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                      child: Text(
                                        request.status.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          if (request.status == "Rejected") {
                                            return Colors.red;
                                          } else if (request.status ==
                                              "Completed") {
                                            return Colors.green;
                                          }
                                          return Colors.blue;
                                        }),
                                      ),
                                    )),
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

  void loadRequests() {
    setState(() {
      isLoading = true;
    });

    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/load_request.php"),
      body: {
        "userid": widget.user.id,
      },
    ).then((response) {
      log(response.body);
      requestList.clear();

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          // numPages = int.parse(jsondata['numofpage']);
          var extractdata = jsondata['data'];
          extractdata['request'].forEach((v) {
            Request request = Request.fromJson(v);
            if (request.status == "requesting" &&
                (request.userPossAvailable == false ||
                    request.ownerPossAvailable == false)) {
              deleteRequest(request);
            } else {
              requestList.add(request);
            }
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  void deleteRequest(Request request) {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/delete_request.php"),
      body: {
        "userid": widget.user.id,
        "reqid": request.reqId,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request cancelled")),
          );
          loadRequests();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed")),
          );
        }
      }
    });
  }

  void loadMoreRequests() {
    if (!isLoading && !reachedEndOfList && curPage < numPages) {
      setState(() {
        isLoading = true;
        curPage++;
      });

      http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_request.php"),
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
              requestList.add(Request.fromJson(v));
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

  void updateRequestStatus(String reqId, String status) {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/update_req_status.php"),
      body: {
        "reqid": reqId,
        "status": status,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request Rejected")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update status")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update status")),
        );
      }
    });
  }

  void updateRequest(Request request) {
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/update_request.php"),
      body: {
        "req_id": request.reqId.toString(),
        "status": request.status.toString(),
        "owner_poss_id": request.ownerPossId,
        "user_poss_id": request.userPossId,
        "cash_input": request.cashInput.toString(),
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Congratulations, Barter Success!")),
          );
          loadRequests();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to barter")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to barter")),
        );
      }
    });
  }
}
