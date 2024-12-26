import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const SkipButton({
    this.text = "Skip",
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle().copyWith(
          side: const WidgetStatePropertyAll(BorderSide(width: 0, color: Colors.transparent)),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent)
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}