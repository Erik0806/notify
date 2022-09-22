import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:notify/utils/color_utils.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    required this.icon,
    this.onTap,
    this.margin = 10,
    this.borderRadius,
    this.inset = false,
  });
  final Icon icon;
  final onTap;
  final double margin;
  final BorderRadius? borderRadius;
  final bool inset;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isPressed = true;
        });

        await Future.delayed(const Duration(milliseconds: 220));
        setState(() {
          isPressed = false;
        });
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: AnimatedContainer(
        margin: EdgeInsets.all(widget.margin),
        height: 60,
        width: 60,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ColorUtils.darken(
                            Theme.of(context).backgroundColor, 60)
                        : ColorUtils.darken(
                            Theme.of(context).backgroundColor, 30),
                    offset: const Offset(6, 6),
                    blurRadius: 10,
                    spreadRadius: 1,
                    inset: widget.inset,
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ColorUtils.lighten(
                            Theme.of(context).backgroundColor, 15)
                        : ColorUtils.lighten(
                            Theme.of(context).backgroundColor, 70),
                    offset: const Offset(-6, -6),
                    blurRadius: 10,
                    spreadRadius: 1,
                    inset: widget.inset,
                  )
                ],
        ),
        child: widget.icon,
      ),
    );
  }
}
