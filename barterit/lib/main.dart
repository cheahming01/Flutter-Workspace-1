import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'logoscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barter It🤝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.aBeeZeeTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      home: const LogoScreen(),
    );
  }
}
