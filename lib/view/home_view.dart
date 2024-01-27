import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';
import 'machines_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final machines = Provider.of<Controller>(context).machines;

    return Scaffold(
      // appBar: AppBar(title: const Text('Is this working')),
      body: machines.isEmpty
          ? const Center(child: Text('No machines'))
          : GridView.builder(
              itemCount: machines.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25.0,
                crossAxisSpacing: 25.0,
              ),
              itemBuilder: (BuildContext context, index) =>
                  MachinesView(machines[index]),
            ),
    );
  }
}
