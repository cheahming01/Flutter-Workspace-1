import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/registrationscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mainscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
      User user = User(
                id: "na",
                name: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen(user: user,)),
    );
    return false;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          // SvgPicture.asset(
          //   "assets/images/login.svg",
          //   height: screenHeight * 0.5,
          // ),
          SizedBox(
              height: screenHeight * 0.40,
              width: screenWidth,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          controller: _nameEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "name must be longer than 5"
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          controller: _passEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "password must be longer than 5"
                              : null,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.lock),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            //checkColor: Colors.white,
                            //activeColor: Colors.red,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              saveremovepref(value!);
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: null,
                              child: const Text('Remember Me',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: screenWidth / 3,
                            height: 50,
                            elevation: 10,
                            onPressed: onLogin,
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onError,
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ]),
                  )
                ]),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _goToRegister,
            child: const Text(
              "New account?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: _forgotDialog,
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      )),
    ),);
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String name = _nameEditingController.text;
    String pass = _passEditingController.text;
    print(pass);
    try {
      http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
          body: {
            "name": name,
            "password": pass,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            print(user.name);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (content) => MainScreen(
                    user: user,
                  ),
                ));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {
        // Time has run out, do what you wanted to do.
      });
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  void _forgotDialog() {}

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String name = _nameEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('name', name);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      //delete preference
      await prefs.setString('name', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _nameEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = (prefs.getString('name')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _nameEditingController.text = name;
        _passEditingController.text = password;
      });
    }
  }
}
