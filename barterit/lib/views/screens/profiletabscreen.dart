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

  @override
  void initState() {
    super.initState();
    print("Profile");
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

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Show login dialog after the frame is rendered
      if (loginRequired) {
        showLoginDialog();
        setState(() {
          loginRequired = false;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
            Container(
              width: screenWidth,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Text(
                  "PROFILE SETTINGS",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("LOGIN"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                      );
                    },
                    child: Text("REGISTRATION"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
