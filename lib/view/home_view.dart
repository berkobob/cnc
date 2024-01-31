import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../controller/devices.dart';
import '../model/device.dart';
import 'device_view.dart';

final log = Logger('HomePage');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Devices();
  late final Stream<List<Device>> stream;

  @override
  void initState() {
    super.initState();
    stream = controller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Device>>(
          stream: stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: Text('No devices connected'));
              case ConnectionState.active:
                return GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.horizontal,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                    children: snapshot.data!
                        .map((device) => DeviceView(device))
                        .toList());
              case ConnectionState.done:
                return const Center(child: Text('All done'));
            }
          }),
    );
  }
}
