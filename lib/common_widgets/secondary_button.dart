import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? trailingIcon;
  const SecondaryButton(
      {super.key, this.onPressed, required this.text, this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
