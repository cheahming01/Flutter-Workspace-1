import 'package:barterit/views/screens/barteroption.dart';
import 'package:barterit/views/screens/buyerdetailscreen.dart';
import 'package:barterit/views/screens/topupscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/possession.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

// for buyer screen

class BuyerTabScreen extends StatefulWidget {
  final User user;
  const BuyerTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<BuyerTabScreen> createState() => _BuyerTabScreenState();
}

class _BuyerTabScreenState extends State<BuyerTabScreen> {
  String maintitle = "Buyer";
  List<Possession> possessionList = <Possession>[];
  late double screenHeight, screenWidth;
  late int axiscount = 1;
  TextEditingController searchController = TextEditingController();
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;
  String ownerPossId = "";

  late ScrollController _scrollController;
  bool isLoading = false;
  bool reachedEndOfList = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    loadPossessions(1);
    print("Buyer");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    print("dispose");
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Barter It🤝"),
              MoneyBar(user: widget.user),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (search) {
                        searchPossession(search);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      loadPossessions(1, clearList: true);
                    },
                    child: Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: possessionList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    "$numberofresult possessions Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 1.6,
                    ),
                    itemCount: possessionList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < possessionList.length) {
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
                                  Text(
                                    possessionList[index].userName.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Possession singlePossession =
                                          Possession.fromJson(
                                              possessionList[index].toJson());
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
                                            if (possessionList[index]
                                                    .userName ==
                                                widget.user.name) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "You cannot trade with your own possession."),
                                                ),
                                              );
                                            } else {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    child: BarterOption(
                                                        user: widget.user,
                                                        ownerPossId: possessionList[
                                                                    index]
                                                                .possessionId ??
                                                            ''),
                                                  );
                                                },
                                              );
                                            }
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (possessionList[index]
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
                                                    if (possessionList[index]
                                                            .goods_checked
                                                            .toString() ==
                                                        "true")
                                                      SizedBox(width: 10),
                                                    if (possessionList[index]
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
                                                          color: Colors.yellow,
                                                        ),
                                                      ),
                                                    if (possessionList[index]
                                                            .services_checked
                                                            .toString() ==
                                                        "true")
                                                      SizedBox(width: 10),
                                                    if (possessionList[index]
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
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    if (possessionList[index]
                                                            .other_checked
                                                            .toString() ==
                                                        "true")
                                                      SizedBox(width: 10),
                                                    if (possessionList[index]
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
                              SizedBox(height: 8),
                              Text(
                                possessionList[index].possessionName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (reachedEndOfList) {
                          return Center(
                            child: Text(
                              "You have reached the end of the list",
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void loadPossessions(int pg, {bool loadMore = false, bool clearList = true}) {
    if (loadMore) {
      setState(() {
        isLoading = true;
      });
    }
    final params = {
      "publish": true.toString(),
      "available": true.toString(),
      "pageno": pg.toString(),
    };
    http
        .post(
            Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
            body: params)
        .then((response) {
      print(response.body);
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numofpage);
          var extractdata = jsondata['data'];
          List<dynamic> possessionData = extractdata['possessions'];
          possessionData.shuffle();
          if (clearList) possessionList.clear();
          extractdata['possessions'].forEach((v) {
            possessionList.add(Possession.fromJson(v));
          });
          print(possessionList[0].possessionName);
        }
        setState(() {});
      }
      if (loadMore) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void searchPossession(String search,
      {bool loadMore = false, bool clearList = true}) {
    if (loadMore) {
      setState(() {
        isLoading = true;
      });
    }
    final params = {
      "search": search,
    };
    http
        .post(
            Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
            body: params)
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numofpage);
          var extractdata = jsondata['data'];
          if (clearList) possessionList.clear();
          extractdata['possessions'].forEach((v) {
            possessionList.add(Possession.fromJson(v));
          });
          print(possessionList[0].possessionName);
        }
        setState(() {});
      }
      if (loadMore) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void loadMorePossessions() {
    if (!isLoading && curpage < numofpage) {
      curpage++;
      loadPossessions(curpage, loadMore: true, clearList: false);
    } else {
      setState(() {
        reachedEndOfList = true;
      });
    }
  }
}

class MoneyBar extends StatelessWidget {
  final User user;

  const MoneyBar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the topup.dart screen here
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TopUpScreen(user: user)), // Replace 'TopUpScreen' with the actual name of your topup screen class.
        );
      },
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              user.cash ?? '0',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
