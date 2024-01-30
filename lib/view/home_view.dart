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
          : GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              mainAxisSpacing: 25.0,
              crossAxisSpacing: 25.0,
              addAutomaticKeepAlives: true,
              cacheExtent: double.maxFinite,
              children:
                  machines.map((machine) => MachinesView(machine)).toList()),
    );
  }
}
