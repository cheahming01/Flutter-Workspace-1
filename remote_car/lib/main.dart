import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text('Remote Car Controller'),
      ),
      body: const MainApp(),
    ),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String message = '';

  void sendMessage(String msg) {
    // send the message to the remote car
    setState(() {
      message = msg;
    });

    // Show a SnackBar notification with the message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/car.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Tap the arrow buttons to control the car',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  color: Colors.blue,
                  onPressed: () {
                    sendMessage('Forward');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.blue,
                    onPressed: () {
                      sendMessage('Turn Left');
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.stop),
                    color: Colors.blue,
                    onPressed: () {
                      sendMessage('Stop');
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    color: Colors.blue,
                    onPressed: () {
                      sendMessage('Turn Right');
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  color: Colors.blue,
                  onPressed: () {
                    sendMessage('Reverse');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
