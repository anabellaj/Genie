import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/view/widgets/more_less_btns.dart';

class MyTimeLimitWidget extends StatefulWidget {
  const MyTimeLimitWidget({super.key, required this.setTimeLimit});
  final Function(int timeSet) setTimeLimit;

  @override
  _MyTimeLimitWidgetState createState() => _MyTimeLimitWidgetState();
}

class _MyTimeLimitWidgetState extends State<MyTimeLimitWidget> {
  int _timeLimit = 60; // Initial time limit in minutes

  void _incrementTimeLimit() {
    setState(() {
      _timeLimit =
          _timeLimit < 120 ? _timeLimit + 5 : _timeLimit; // Limit max value
      widget.setTimeLimit(_timeLimit);
    });
  }

  void _decrementTimeLimit() {
    setState(() {
      _timeLimit =
          _timeLimit > 5 ? _timeLimit - 5 : _timeLimit; // Limit min value
      widget.setTimeLimit(_timeLimit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'Tiempo limite: ',
        style: genieThemeDataDemo.textTheme.displayLarge,
      ),
      Row(
        children: [
          DecrementButton(onPressed: _decrementTimeLimit),
          Text(
            '$_timeLimit minutos',
            style: genieThemeDataDemo.textTheme.displayLarge,
          ),
          IncrementButton(onPressed: _incrementTimeLimit),
        ],
      ),
    ]);
  }
}
