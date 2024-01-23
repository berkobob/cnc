import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Clock extends StatelessWidget {
  const Clock({super.key});

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
            GaugeRange(startValue: 5.0, endValue: 10.0, color: Colors.yellow),
            GaugeRange(startValue: 10.0, endValue: 20.0, color: Colors.green),
            GaugeRange(startValue: 20.0, endValue: 30.0, color: Colors.red),
          ],
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 20,
              needleEndWidth: 5.0,
            )
          ],
        ),
      ]),
    );
  }
}
