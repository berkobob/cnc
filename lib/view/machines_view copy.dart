import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../model/device.dart';
import '../widgets/machine_widget.dart';

final log = Logger('MachinesView');

class MachinesView extends StatefulWidget {
  final Device device;
  const MachinesView(this.device, {super.key});

  @override
  State<MachinesView> createState() => _MachinesViewState();
}

class _MachinesViewState extends State<MachinesView>
    with AutomaticKeepAliveClientMixin {
  late Device device;
  late Stream stream;

  @override
  void initState() {
    super.initState();
    device = widget.device;
    stream = device.stream;
  }

  @override
  void didUpdateWidget(MachinesView oldMachinesView) {
    // log.finest('in didUpdateWidget: ${device.name}');
    super.didUpdateWidget(oldMachinesView);

    // if (oldMachinesView.device != widget.device) {
    //   oldMachinesView.device.close();
    //   device = widget.device;
    //   stream = device.stream;
    //   log.fine('A new machine');
    // }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      device.close;
    } catch (e) {
      log.finer(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Starting socket server...'));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              // device.lastMsg = snapshot.data;
              // if (device.alert != null) {
              //   final string = device.alert!;
              //   device.alert = null;
              //   _showSnackbar(context: context, string: string);
              // }
              return Center(
                  child: GestureDetector(
                      onTap: () => device.shutdown(),
                      child: MachineWidget(snapshot.data)));
            case ConnectionState.done:
              _showAlert(
                  context: context,
                  string: 'Connection to ${device.name} has been lost');
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

  @override
  bool get wantKeepAlive => true;
}
