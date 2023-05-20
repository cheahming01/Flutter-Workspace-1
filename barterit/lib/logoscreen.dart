import 'dart:async';
// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:barter_it/myconfig.dart';
import 'package:barterit/splashscreen2.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'models/user.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => LogoScreenState();
}

class LogoScreenState extends State<LogoScreen> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final Animation<double> _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  @override
  void initState() {
    super.initState();
    _controller.forward();
    //checkAndLogin();
    //loadPref();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const SplashScreen2())));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RotationTransition(
      turns: _animation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("assets/images/logo.png"),
      ),
    ));
  }

  // checkAndLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = (prefs.getString('email')) ?? '';
  //   String password = (prefs.getString('pass')) ?? '';
  //   bool ischeck = (prefs.getBool('checkbox')) ?? false;
  //   late User user;
  //   if (ischeck) {
  //     http.post(Uri.parse("${MyConfig().SERVER}/mynelayan/php/login_user.php"),
  //         body: {"email": email, "password": password}).then((response) {
  //       if (response.statusCode == 200) {
  //         var jsondata = jsonDecode(response.body);
  //         user = User.fromJson(jsondata['data']);
  //         Timer(
  //             const Duration(seconds: 3),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => SplashScreen(user: user))));
  //       } else {
  //         user = User(
  //             id: "na",
  //             name: "na",
  //             email: "na",
  //             phone: "na",
  //             datereg: "na",
  //             password: "na",
  //             otp: "na");
  //         Timer(
  //             const Duration(seconds: 4),
  //             () => Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (content) => SplashScreen(user: user))));
  //       }
  //     }).timeout(const Duration(seconds: 5));
  //   } else {
  //     user = User(
  //         id: "na",
  //         name: "na",
  //         email: "na",
  //         phone: "na",
  //         datereg: "na",
  //         password: "na",
  //         otp: "na");
  //     Timer(
  //         const Duration(seconds: 3),
  //         () => Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (content) => MainScreen(user: user))));
  //   }
  // }
}
