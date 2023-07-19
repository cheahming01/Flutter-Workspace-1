import 'package:flutter/material.dart';

class ReqOption extends StatefulWidget {
  @override
  _ReqOptionState createState() => _ReqOptionState();
}

class _ReqOptionState extends State<ReqOption> {
  late PageController _pageController;
  int _currentPage = 0;
  List<String> options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: options.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blue, // Replace with your desired color
            child: Center(
              child: Text(
                options[index],
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
