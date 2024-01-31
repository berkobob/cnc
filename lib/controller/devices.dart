import 'dart:async';

import 'package:logging/logging.dart';

import '../model/device.dart';
import '../services/socket_server.dart';

final log = Logger('Devices');

class Devices {
  final _server = SocketServer();
  final List<Device> _devices = List<Device>.empty(growable: true);

  Devices() {
    _server.stream.listen((Device device) {
      log.info('New device: $device');
      final int index =
          _devices.indexWhere((each) => each.address == device.address);
      if (index == -1) {
        _devices.add(device);
      } else {
        _devices.removeAt(index);
        _devices.insert(index, device);
      }
      _controller.add(_devices);
      log.fine('Added $device to devices. Now ${_devices.length} devices');
    });
  }

  final StreamController<List<Device>> _controller =
      StreamController<List<Device>>();
  Stream<List<Device>> get stream => _controller.stream;
}
