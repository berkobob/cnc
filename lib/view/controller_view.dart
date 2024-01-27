import 'package:flutter/material.dart';

import '../model/machine_model.dart';
import 'machines_view.dart';

class ControllerView extends StatelessWidget {
  const ControllerView(this.machines, {super.key});
  final List<Machine> machines;

  @override
  Widget build(BuildContext context) {
    print('building contollerview with ${machines.length} machines.');
    return GridView.builder(
        itemCount: machines.length,
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 25.0,
          crossAxisSpacing: 25.0,
        ),
        itemBuilder: (BuildContext context, index) =>
            MachinesView(machines[index]));
  }
}
