import 'package:barterit/views/screens/buyerdetailscreen.dart';
import 'package:barterit/views/screens/storagepage.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/possession.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

//for buyer screen

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

  @override
  void initState() {
    super.initState();
    loadPossessions(1);
    print("Buyer");
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
    // if (screenWidth > 600) {
    //   axiscount = 3;
    // } else {
    //   axiscount = 2;
    // }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Barter It"),
              MoneyBar(),
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
                        searchpossession(search);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      loadPossessions(
                          1); // Call the function to refresh and shuffle the list
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
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadPossessions(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 1.6,
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
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.8,
                                                  child: StoragePage(
                                                      user: widget.user),
                                                );
                                              },
                                            );
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
                              SizedBox(height: 8),
                              Text(
                                possessionList[index].possessionName.toString(),
                                style: const TextStyle(fontSize: 20),
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

  void loadPossessions(int pg) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {
          "publish": true.toString(),
          "pageno": pg.toString()
        }).then((response) {
      print(response.body);
      log(response.body);
      possessionList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numofpage);
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

  void searchpossession(String search) {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_possessions.php"),
        body: {"search": search}).then((response) {
      //print(response.body);
      log(response.body);
      possessionList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numofpage);
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

class MoneyBar extends StatelessWidget {
  const MoneyBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "0",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
