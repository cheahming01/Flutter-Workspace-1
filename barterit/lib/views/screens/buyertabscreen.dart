import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

//for buyer screen

class BuyerTabScreen extends StatefulWidget {
  final User user;
  const BuyerTabScreen({super.key, required this.user});

  @override
  State<BuyerTabScreen> createState() => _BuyerTabScreenState();
}

class _BuyerTabScreenState extends State<BuyerTabScreen> {
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    print("Buyer");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
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
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(child: Text("BuyerTabScreen Body")),
    );
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