import 'package:flutter/material.dart';

import '../model/machine_model.dart';

class MachineView extends StatefulWidget {
  final Machine machine;
  const MachineView({super.key, required this.machine});

  @override
  State<MachineView> createState() => _MachineViewState();
}

class _MachineViewState extends State<MachineView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.machine.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(
                  child: Text('New connection from incoming...'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: Text(snapshot.data.toString()));
            case ConnectionState.done:
              return const Center(child: Text('All done.'));
          }
        });
  }
}
