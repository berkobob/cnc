import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Clock extends StatelessWidget {
  const Clock(this.clock, {super.key});
  final double clock;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          minimum: 5,
          maximum: 30,
          ranges: <GaugeRange>[
            GaugeRange(startValue: 5.0, endValue: 12.5, color: Colors.yellow),
            GaugeRange(startValue: 12.5, endValue: 22.5, color: Colors.green),
            GaugeRange(startValue: 22.5, endValue: 30.0, color: Colors.red),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: clock,
              needleEndWidth: 5.0,
            )
          ],
        ),
      ]),
    );
  }
}
