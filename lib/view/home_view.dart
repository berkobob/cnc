import 'package:flutter/material.dart';

import '../controller/controller.dart';
import 'controller_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Controller();
    return Scaffold(
      appBar: AppBar(title: const Text('Is this working')),
      body: StreamBuilder(
          stream: controller.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text('No connection state'));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return ControllerView(snapshot.data);
              // return Center(child: MachineView(machine: snapshot.data));
              case ConnectionState.done:
                return const Center(child: Text('All done.'));
            }
          }),
    );
  }
}
