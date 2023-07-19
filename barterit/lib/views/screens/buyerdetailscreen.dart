import 'package:barterit/views/screens/barteroption.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/possession.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';

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
  bool get isCurrentUser =>
      widget.userPossession.userName.toString() == widget.user.name;
  String ownerPossId = "";
  @override
  void initState() {
    super.initState();
    loadPossessionImages();
    ownerPossId = widget.userPossession.possessionId.toString();
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
              child: ListView(
                // Replace Column with ListView
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
                          color: widget.userPossession.possessionType == 'Goods'
                              ? Colors.yellow
                              : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.userPossession.possessionType!,
                          style: TextStyle(
                            color: Colors.black,
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
                  SizedBox(height: 8),
                  Text(
                    "${DateTime.parse(widget.userPossession.dateOwned.toString()).day.toString().padLeft(2, '0')}/${DateTime.parse(widget.userPossession.dateOwned.toString()).month.toString().padLeft(2, '0')}/${DateTime.parse(widget.userPossession.dateOwned.toString()).year.toString().substring(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ClipRect(
                    // Wrap the Container with ClipRect
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom
            : bottomSheetHeight,
        color: Colors.white,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: BarterOption(user: widget.user, ownerPossId: ownerPossId),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          if (widget.userPossession.userName == widget.user.name) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You cannot trade with your own possession."),
              ),
            );
          } else {
            toggleBottomSheetVisibility();
          }
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
