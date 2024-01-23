import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Temp extends StatelessWidget {
  const Temp(this.temp, {super.key});
  final double temp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.0,
      width: 40.0,
      child: SfLinearGauge(
        orientation: LinearGaugeOrientation.vertical,
        minimum: 20.0,
        maximum: 80.0,
        ranges: const <LinearGaugeRange>[
          LinearGaugeRange(
              startValue: 0.0, endValue: 40.0, color: Colors.green),
          LinearGaugeRange(
              startValue: 40.0, endValue: 60.0, color: Colors.yellow),
          LinearGaugeRange(startValue: 60.0, endValue: 80.0, color: Colors.red)
        ],
        // barPointers: [LinearBarPointer(value: 50)],
        markerPointers: [LinearShapePointer(value: temp)],
        axisLabelStyle: const TextStyle(fontSize: 10.0),
        tickPosition: LinearElementPosition.outside,
      ),
    );
  }
}
