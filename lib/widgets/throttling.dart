import 'package:cnc/model/msg_model.dart';
import 'package:flutter/material.dart';

class Throttling extends StatelessWidget {
  final ThrottleState frequency;
  final ThrottleState overheat;
  final ThrottleState voltage;

  const Throttling({
    required this.frequency,
    required this.overheat,
    required this.voltage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(Icons.power, color: color(voltage)),
      Icon(Icons.access_time, color: color(frequency)),
      Icon(Icons.thermostat, color: color(overheat)),
    ]);
  }

  Color color(ThrottleState state) => switch (state) {
        ThrottleState.none => Colors.green,
        ThrottleState.now => Colors.red,
        ThrottleState.previously => Colors.yellow,
      };
}
