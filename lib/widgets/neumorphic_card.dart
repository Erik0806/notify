import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class NeumorphicCard extends StatefulWidget {
  const NeumorphicCard({
    super.key,
    this.child,
    this.margin = 10,
    this.borderRadius,
    this.height,
    this.color,
    this.width,
    this.blurRadius = 10,
  });
  final Widget? child;
  final double margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final double blurRadius;

  @override
  State<NeumorphicCard> createState() => _NeumorphicCardState();
}

class _NeumorphicCardState extends State<NeumorphicCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.all(widget.margin),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: widget.color ?? Theme.of(context).colorScheme.background,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorUtils.darken(
                    widget.color ?? Theme.of(context).backgroundColor, 60)
                : ColorUtils.darken(
                    widget.color ?? Theme.of(context).backgroundColor, 30),
            offset: const Offset(6, 6),
            blurRadius: widget.blurRadius,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? ColorUtils.lighten(
                    widget.color ?? Theme.of(context).backgroundColor, 15)
                : ColorUtils.lighten(
                    widget.color ?? Theme.of(context).backgroundColor, 70),
            offset: const Offset(-6, -6),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [Spacer()],
          ),
          widget.child ?? Container(),
        ],
      ),
    );
  }
}
