import 'dart:async';

import 'package:flutter/material.dart';

class Counter extends StatefulWidget{

  final DateTime start;
  final String task;
  const Counter(this.start,this.task);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  DateTime now = DateTime.now();
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t){

        setState(
                () {
              now = DateTime.now(
              );
            }
        );

    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var duration = now.difference(widget.start);
    return Text("${widget.task} : ${printDuration(duration)}");
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}