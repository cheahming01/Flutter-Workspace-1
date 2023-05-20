import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

// for profile screen

class NewItemTabScreen extends StatefulWidget {
  final User user;

  const NewItemTabScreen({super.key, required this.user});

  @override
  State<NewItemTabScreen> createState() => _NewItemTabScreenState();
}

class _NewItemTabScreenState extends State<NewItemTabScreen> {
  String maintitle = "NewItem";

  @override
  void initState() {
    super.initState();
    print("New Item");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Text(maintitle),
    );
  }
}