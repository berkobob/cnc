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
  late Stream stream;

  @override
  void initState() {
    super.initState();
    stream = widget.machine.stream;
  }

  @override
  void didUpdateWidget(MachinesView oldMachinesView) {
    super.didUpdateWidget(oldMachinesView);

    if (oldMachinesView.machine != widget.machine) {
      oldMachinesView.machine.socket.destroy();
      stream = widget.machine.stream;
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.machine.socket.destroy();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.machine.lastMsg = snapshot.data;
              return Center(child: MachineWidget(snapshot.data));
            case ConnectionState.done:
              // Provider.of<Controller>(context).kill(widget.machine);
              return MachineWidget(snapshot.data, inactive: true);
            // Center(
            //     child: Text(
            //         'Connection from ${widget.machine.lastMsg?.name} at ${widget.machine.lastMsg?.address} lost.\n${widget.machine.lastMsg}'));
          }
        });
  }
}
