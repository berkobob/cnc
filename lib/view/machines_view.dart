import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../model/machine_model.dart';
import '../widgets/machine_widget.dart';

final log = Logger('MachinesView');

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
    try {
      widget.machine.socket.destroy();
    } catch (e) {
      log.finer(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Starting socket server...'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              widget.machine.lastMsg = snapshot.data;
              if (widget.machine.alert != null) {
                final string = widget.machine.alert!;
                widget.machine.alert = null;
                _showSnackbar(context: context, string: string);
              }
              return Center(
                  child: GestureDetector(
                      onTap: () => widget.machine.shutdown(),
                      child: MachineWidget(snapshot.data)));
            case ConnectionState.done:
              _showAlert(
                  context: context,
                  string:
                      'Connection to ${widget.machine.lastMsg?.name} has been lost');
              return snapshot.data == null
                  ? const Placeholder()
                  : MachineWidget(snapshot.data, inactive: true);
          }
        });
  }

  void _showAlert({required BuildContext context, required String string}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(
                const Duration(seconds: 3), () => Navigator.of(context).pop());
            return AlertDialog(
              // title: const Text('A new message'),
              content: Text(string),
            );
          });
    });
  }

  void _showSnackbar({required BuildContext context, required String string}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(string),
      ));
    });
  }
}
