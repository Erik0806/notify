import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class NotifyLogo extends StatelessWidget {
  const NotifyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            child: Container(
              height: 120,
              width: 120,
              color:
                  Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Theme.of(context).colorScheme.background.lighten(10)
                      : Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Image.asset(
            'assets/icon.png',
            cacheHeight: 100,
            cacheWidth: 100,
          ),
        ],
      ),
    );
  }
}
