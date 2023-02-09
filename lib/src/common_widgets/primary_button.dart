import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? trailingIcon;
  const PrimaryButton(
      {super.key, this.onPressed, required this.text, this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Text(text),
          Icon(trailingIcon),
        ],
      ),
    );
  }
}
