import 'dart:convert';

import 'package:barterit/views/screens/storagepage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterit/models/possession.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:http/http.dart' as http;

class BuyerDetailScreen extends StatefulWidget {
  final Possession userPossession;
  final User user;
  const BuyerDetailScreen({
    Key? key,
    required this.userPossession,
    required this.user,
  }) : super(key: key);

  @override
  State<BuyerDetailScreen> createState() => _BuyerDetailScreenState();
}

class _BuyerDetailScreenState extends State<BuyerDetailScreen> {
  late List<String> imageUrls;
  int currentIndex = 0;
  bool isBottomSheetVisible = false;
  double bottomSheetHeight = 0.0;

  @override
  void initState() {
    super.initState();
    loadPossessionImages();
  }

  void loadPossessionImages() {
    imageUrls = [];
    for (int i = 1; i <= 3; i++) {
      String imageUrl =
          "${MyConfig().SERVER}/barterit/assets/possessions/${widget.userPossession.possessionId}/$i.png";
      imageUrls.add(imageUrl);
    }
  }

  void toggleBottomSheetVisibility() {
    setState(() {
      isBottomSheetVisible = !isBottomSheetVisible;
      bottomSheetHeight =
          isBottomSheetVisible ? MediaQuery.of(context).size.height * 0.5 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyer Detail Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return AspectRatio(
                      aspectRatio: 1, // Set aspect ratio to make it square
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrls[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      imageUrls.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentIndex
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.userPossession.possessionName!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.userPossession.possessionType!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.userPossession.userName.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        widget.userPossession.possessionDesc ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: bottomSheetHeight,
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: StoragePage(user: widget.user),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          toggleBottomSheetVisibility();
        },
        child: Text(
          'TRADE',
          style: TextStyle(fontSize: 12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
