import 'package:flutter/material.dart';
import 'package:notify/widgets/neumorphic_card.dart';

class SettingButton extends StatefulWidget {
  const SettingButton({
    super.key,
    required this.description,
    required this.child,
  });
  final String description;
  final Widget child;

  @override
  State<SettingButton> createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                softWrap: true,
                maxLines: 8,
                widget.description,
                overflow: TextOverflow.ellipsis,
                textWidthBasis: TextWidthBasis.parent,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            widget.child,
          ],
        ),
      ),
    );
  }
}
