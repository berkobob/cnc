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
    print('in init state');
    stream = widget.machine.stream;
  }

  @override
  void didUpdateWidget(MachinesView machinesView) {
    super.didUpdateWidget(machinesView);
    machinesView.machine.socket.destroy();
    print(stream == widget.machine.stream);
    print(stream == machinesView.machine.stream);
    stream == widget.machine.stream;
    // stream = machinesView.machine.stream;
  }

  @override
  void dispose() {
    super.dispose();
    print('Does dispose happen');
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
              return Center(
                  child: Text(
                      'Connection from ${widget.machine.lastMsg?.name} at ${widget.machine.lastMsg?.address} lost.\n${widget.machine.lastMsg}'));
          }
        });
  }
}
