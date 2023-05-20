import 'package:barterit/views/screens/profiletabscreen.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'buyertabscreen.dart';
import 'newitemtabscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      BuyerTabScreen(
        user: widget.user,
      ),
      ProfileTabScreen(
        user: widget.user,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(100),
      //   child: AppBar(
      //     title: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Text("Barter It"),
      //         MoneyBar(),
      //       ],
      //     ),
      //     bottom: PreferredSize(
      //       preferredSize: Size.fromHeight(56),
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 16),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: TextField(
      //                 decoration: InputDecoration(
      //                   hintText: "Search",
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(30),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   contentPadding:
      //                       EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      //                   prefixIcon: Icon(Icons.search),
      //                 ),
      //               ),
      //             ),
      //             IconButton(
      //               onPressed: () {},
      //               icon: Icon(Icons.notifications),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => NewItemTabScreen(user: widget.user)));
        },
        child: Icon(Icons.add),
      ),
      extendBody: true,
      body: tabchildren[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.store_mall_directory),
                label: "Shop",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
          BottomAppBar(
            shape: CircularNotchedRectangle(),
          )
        ],
      ),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Shop";
      }
      if (_currentIndex == 1) {
        maintitle = "Profile";
      }
    });
  }
}

// class MoneyBar extends StatelessWidget {
//   const MoneyBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.green,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.attach_money,
//             color: Colors.white,
//           ),
//           SizedBox(width: 5),
//           Text(
//             "0",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
