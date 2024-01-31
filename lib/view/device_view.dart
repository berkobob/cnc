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
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (device.isClosed) {
      device = widget.device;
      stream = device.stream;
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
              if (device.first) {
                _showSnackbar(
                    context: context,
                    string:
                        'A new connection is joining the party from ${device.address}');
                device.first = false;
              }
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
