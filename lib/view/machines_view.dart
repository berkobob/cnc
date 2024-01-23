import 'package:flutter/material.dart';

import '../model/machine_model.dart';
import '../widgets/machine_widget.dart';

class MachinesView extends StatefulWidget {
  final Machine machine;
  const MachinesView(this.machine, {super.key});

  @override
  State<MachinesView> createState() => _MachinesViewState();
}

class _MachinesViewState extends State<MachinesView> {
  Stream? stream;
  @override
  Widget build(BuildContext context) {
    stream ??= widget.machine.stream;
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                  child: Text('New connection from incoming...'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: MachineWidget(snapshot.data));
            case ConnectionState.done:
              return const Center(child: Text('All done.'));
          }
        });
  }
}
