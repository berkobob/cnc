import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

import 'msg_model.dart';

final log = Logger('Device');

class Device {
  final Socket _socket;
  final StreamController<Msg> _deviceController = StreamController<Msg>();

  bool first = true;
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
      onDone: () => _deviceController.close(),
    );
  }

  Future close() async {
    await _deviceController.close();
  }

  void shutdown() {
    log.finest('Shutting down $name');
  }

  bool get isClosed => _deviceController.isClosed;

  @override
  String toString() => 'Name: $name, Address: $address';
}
