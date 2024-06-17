import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    int timeLeft = 60;
    void _startTimer() {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          timeLeft--;
        });
      });
    }

    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      decoration: BoxDecoration(
        color: genieThemeDataDemo.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        // alignment: Alignment.center,
        child: Text(
          timeLeft.toString(),
          style: genieThemeDataDemo.primaryTextTheme.bodyMedium,
        ),
      ),
    );
  }
}
