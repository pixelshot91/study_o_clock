import 'package:flutter/material.dart';
import 'package:study_o_clock/stopwatch.dart';

void main() {
  runApp(const MyApp());
}

class SoCTheme {
  const SoCTheme({required this.name, required this.backgroundFilepath});

  final String name;
  final String backgroundFilepath;
}

const themes = [
  SoCTheme(name: "meadows", backgroundFilepath: "moving_castle_meadow.webp"),
  SoCTheme(name: "Lake", backgroundFilepath: "lake_and_mountain.jpg"),
];

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
  SoCTheme theme = themes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/${theme.backgroundFilepath}",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Tooltip(message: "Concours dans X jours !", child: Icon(Icons.calendar_month)),
                Spacer(),
                DropdownButton(
                  value: theme,
                  icon: Icon(Icons.color_lens_outlined),
                  items: themes
                      .map((theme) => DropdownMenuItem(
                            value: theme,
                            child: Text(theme.name),
                          ))
                      .toList(),
                  onChanged: (newTheme) {
                    setState(() {
                      theme = newTheme!;
                    });
                  },
                ),
                // Icon(Icons.color_lens),
              ],
            ),
          ),
          StopWatchSection(),
        ],
      ),
    );
  }
}
