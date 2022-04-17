import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pejskari/util/TimeFormatUtil.dart';

/// This class represents stopwatch with rendered time as text.
class StopwatchText extends StatefulWidget {
  const StopwatchText({Key? key, required this.stopwatch, required this.textStyle});
  final Stopwatch stopwatch;
  final TextStyle textStyle;

  @override
  StopwatchTextState createState() => StopwatchTextState(stopwatch: stopwatch, textStyle: textStyle);
}

class StopwatchTextState extends State<StopwatchText> {

  late Timer timer;
  final Stopwatch stopwatch;
  final TextStyle textStyle;

  StopwatchTextState({Key? key, required this.stopwatch, required this.textStyle}) {
    timer = Timer.periodic(const Duration(milliseconds: 50), callback);
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(TimeFormatUtil.printDurationHHMM(stopwatch.elapsed), style: textStyle);
  }
}