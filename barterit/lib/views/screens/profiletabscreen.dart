import 'package:barterit/views/screens/historypage.dart';
import 'package:barterit/views/screens/publishedpage.dart';
import 'package:barterit/views/screens/storagepage.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/views/screens/loginscreen.dart';
import 'package:barterit/views/screens/registrationscreen.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late double screenHeight, screenWidth;
  bool loginRequired = false;
  bool dialogShown = false;
  int currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    if (widget.user.name == "na" && !dialogShown) {
      if (!dialogShown) {
        setState(() {
          loginRequired = true;
        });
      }
      // User is not logged in or registered
    }
  }

  void showLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Required"),
          content: Text("Please log in or sign up to access the profile."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogShown = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("Log In"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                dialogShown = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text("Register"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show login dialog after the frame is rendered
      if (loginRequired) {
        showLoginDialog();
        setState(() {
          loginRequired = false;
        });
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return null;
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text(widget.user.phone.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              child: Container(
                height: screenHeight * 0.05,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPageIndex = 0;
                          });
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Text("Published"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPageIndex = 1;
                          });
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Text("Storage"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentPageIndex = 2;
                          });
                          _pageController.animateToPage(2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                        child: Text("History"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController, 
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return PublishedPage(user: widget.user);
                    case 1:
                      return StoragePage(user: widget.user);
                    case 2:
                      return HistoryPage(user: widget.user);
                    default:
                      return PublishedPage(user: widget.user); 
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
