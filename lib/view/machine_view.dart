import 'package:flutter/material.dart';

import '../model/machine_model.dart';
import '../widgets/machine_widget.dart';

class MachineView extends StatelessWidget {
  const MachineView(this.machine, {super.key});

  final Machine machine;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: machine.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Starting socket server...'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              machine.lastMsg = snapshot.data;
              if (machine.alert != null) {
                final string = machine.alert!;
                machine.alert = null;
                _showSnackbar(context: context, string: string);
              }
              return Center(
                  child: GestureDetector(
                      onTap: () => machine.shutdown(),
                      child: MachineWidget(snapshot.data)));
            case ConnectionState.done:
              _showSnackbar(
                  context: context,
                  string:
                      'Connection to ${machine.lastMsg?.name} has been lost');
              log.warning('Losing $machine');
              return snapshot.data == null
                  ? const Placeholder()
                  : MachineWidget(snapshot.data, inactive: true);
          }
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
