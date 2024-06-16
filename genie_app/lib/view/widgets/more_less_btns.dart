import 'package:flutter/material.dart';

class IncrementButton extends StatelessWidget {
  final Function onPressed;

  const IncrementButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_drop_up,
      ),
      onPressed: () => onPressed(),
    );
  }
}

class DecrementButton extends StatelessWidget {
  final Function onPressed;

  const DecrementButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_drop_down),
      onPressed: () => onPressed(),
    );
  }
}
