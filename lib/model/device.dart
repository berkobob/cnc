import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import 'msg_model.dart';

final log = Logger('Device');

class Device {
  final Socket _socket;
  final StreamController<Msg> _deviceController = StreamController<Msg>();

  String? name;
  final String address;
  Stream<Msg> get stream => _deviceController.stream;

  Device(this._socket) : address = _socket.remoteAddress.address {
    _socket.listen(
      (data) {
        final Msg msg = Msg(jsonDecode(String.fromCharCodes(data)));
        name ??= msg.name;
        _deviceController.add(msg);
      },
      onError: (error) => log.finer(error.toString()),
      onDone: () => log.finer('$this is done'),
    );
    _deviceController.addError('A new device is joing the party from $address');
  }

  Future close() async {
    await _deviceController.close();
  }

  void shutdown() {
    log.finest('Shutting down $name');
  }

  @override
  String toString() => 'Name: $name, Address: $address';
}
