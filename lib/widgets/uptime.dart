import 'package:flutter/material.dart';

class Uptime extends StatelessWidget {
  const Uptime({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 125.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '4D',
            textScaler: TextScaler.linear(1.75),
          ),
          Text(
            '10%',
            textScaler: TextScaler.linear(1.5),
          )
        ],
      ),
    );
  }
}
