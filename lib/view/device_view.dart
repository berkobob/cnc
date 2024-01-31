import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../model/device.dart';
import '../widgets/machine_widget.dart';

final log = Logger('MachinesView');

class DeviceView extends StatefulWidget {
  final Device device;
  const DeviceView(this.device, {super.key});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView>
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
              if (snapshot.hasError) {
                log.shout('Snapshot has error ${snapshot.error}');
                _showSnackbar(context: context, string: '${snapshot.error}');
                return const Center(child: CircularProgressIndicator());
              }
              log.shout('Snapshot has no error ${snapshot.error}');

              if (snapshot.hasData)
                log.shout('Snapshot has data ${snapshot.data}');
              // device.lastMsg = snapshot.data;
              // if (device.alert != null) {
              //   final string = device.alert!;
              //   device.alert = null;
              //   _showSnackbar(context: context, string: string);
              // }
              return Center(
                  child: GestureDetector(
                      onLongPress: () => device.shutdown(),
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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(string),
    ));
    // });
  }

  @override
  bool get wantKeepAlive => true;
}
