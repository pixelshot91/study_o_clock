import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Study o'clock",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final startTime = _startTime;
    const buttonStyle = TextStyle(fontSize: 40);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/moving_castle_meadow.webp",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Conf - Dermato",
                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "2h 37 min this week",
                  style: TextStyle(fontSize: 40),
                ),
                const Expanded(child: SizedBox.shrink()),
                if (startTime != null)
                  Text(formatDuration(startTime), style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton(
                      child: const Text(
                        "Let's take a break !",
                        style: buttonStyle,
                      ),
                      onPressed: () => setState(() {
                        _startTime = DateTime.now();
                      }),
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Study something else",
                        style: buttonStyle,
                      ),
                      onPressed: () => setState(() {
                        _startTime = DateTime.now();
                      }),
                    )
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          )
        ],
      ),
    );
  }

  String formatDuration(DateTime startTime) {
    final d = DateTime.now().difference(startTime);
    return d.toString().split('.').first;
  }
}
