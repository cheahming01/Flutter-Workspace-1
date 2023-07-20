import 'package:barterit/models/user.dart';
import 'package:barterit/views/screens/billscreen.dart';
import 'package:flutter/material.dart';

class TopUpScreen extends StatefulWidget {
  final User user;

  TopUpScreen({required this.user});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Up'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 boxes per row
        padding: EdgeInsets.all(16),
        children: [
          TopUpBox(amount: 1, user: widget.user),
          TopUpBox(amount: 5, user: widget.user),
          TopUpBox(amount: 10, user: widget.user),
          TopUpBox(amount: 20, user: widget.user),
          TopUpBox(amount: 50, user: widget.user),
          TopUpBox(amount: 100, user: widget.user),
        ],
      ),
    );
  }
}

class TopUpBox extends StatelessWidget {
  final int amount;
  final User user;

  const TopUpBox({Key? key, required this.amount, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle the top-up logic for the selected amount
        // You can add your own implementation here
        print('Selected amount: $amount');

        // Navigate to BillScreen and pass the user object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillScreen(user: user, totalprice: amount),
          ),
        );
      },
      child: Card(
        child: Center(
          child: Text(
            '\$$amount',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
