import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeGamePage extends StatefulWidget {
  const ShakeGamePage({super.key});

  @override
  State<ShakeGamePage> createState() => _ShakeGamePageState();
}

class _ShakeGamePageState extends State<ShakeGamePage> {
  int score = 0;

  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen((event) {
      double force = event.x * event.x + event.y * event.y + event.z * event.z;

      if (force > 20) {
        setState(() {
          score++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shake Game")),
      body: Center(
        child: Text(
          "Score: $score",
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
