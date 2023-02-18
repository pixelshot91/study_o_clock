import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

enum StopWatchState {
  start,
  selectParam,
  running,
}

const buttonStyle = TextStyle(fontSize: 40);

class StopWatchSection extends StatefulWidget {
  @override
  State<StopWatchSection> createState() => _StopWatchSectionState();
}

class _StopWatchSectionState extends State<StopWatchSection> {
  StopWatchState stopWatchState = StopWatchState.start;

  @override
  Widget build(BuildContext context) {
    switch (stopWatchState) {
      case StopWatchState.start:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Bonjour ! 😀",
                style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  child: const Text(
                    "Let's start working",
                    style: buttonStyle,
                  ),
                  onPressed: () => setState(() {
                    stopWatchState = StopWatchState.selectParam;
                  }),
                ),
              ),
            ),
          ],
        );
      case StopWatchState.selectParam:
        return _SelectParam(
          goToRunningState: () => setState(() {
            stopWatchState = StopWatchState.running;
          }),
        );
      case StopWatchState.running:
        return _Running(selectParam: () => setState(() => stopWatchState = StopWatchState.selectParam));
    }
  }
}

String formatDuration(DateTime startTime) {
  final d = DateTime.now().difference(startTime);
  return d.toString().split('.').first;
}

class _SelectParam extends StatefulWidget {
  const _SelectParam({required this.goToRunningState});

  final void Function() goToRunningState;

  @override
  State<_SelectParam> createState() => _SelectParamState();
}

const categories = ["Conf", "Entrainement", "Relecture"];
final subjects = List.generate(20, (i) => i);

class _SelectParamState extends State<_SelectParam> {
  int? selectedCategory, selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: categories
                        .mapIndexed((i, c) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _ChoiceChip(
                                label: Text(c),
                                onSelected: (bool selected) => setState(() {
                                  selectedCategory = selected ? i : null;
                                }),
                                selected: selectedCategory == i,
                              ),
                            ))
                        .toList()),
              ),
              // SubjectSelection
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        childAspectRatio: 2,
                        children: subjects
                            .mapIndexed((i, subject) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _ChoiceChip(
                                    label: Text("Subject $i"),
                                    selected: selectedSubject == i,
                                    onSelected: (onSelected) {
                                      setState(() {
                                        selectedSubject = onSelected ? i : null;
                                      });
                                    },
                                  ),
                                ))
                            .toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Center(
          child: ElevatedButton(
            onPressed: (selectedCategory != null && selectedSubject != null) ? widget.goToRunningState : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) return Colors.blueAccent.withOpacity(0.5);
                return Colors.blueAccent;
              }),
            ),
            child: const Text("Go", style: buttonStyle),
          ),
        ))
      ],
    );
  }
}

class _Running extends StatefulWidget {
  const _Running({required this.selectParam});

  final void Function() selectParam;

  @override
  State<_Running> createState() => _RunningState();
}

class _RunningState extends State<_Running> {
  DateTime _startTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // ignore: no-empty-block
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startTime = _startTime;

    return Center(
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
                  widget.selectParam();
                }),
              )
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.selected, required this.onSelected});

  final Widget label;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      padding: const EdgeInsets.all(20),
      label: label,
      selected: selected,
      onSelected: onSelected,
      selectedColor: Colors.blueAccent,
      backgroundColor: Colors.blueAccent.withOpacity(0.2),
    );
  }
}
