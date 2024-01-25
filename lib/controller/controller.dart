import 'dart:async';
import 'dart:io';

import 'package:cnc/model/machine_model.dart';

import '../services/log.dart';

class Controller {
  final List<Machine> _machines = List.empty(growable: true);

  Stream<List<Machine>> get stream async* {
    final server =
        await ServerSocket.bind(InternetAddress.anyIPv4, port, shared: false);
    log.info('Server running on ${server.address}');
    await for (Socket socket in server) {
      yield _machines..add(Machine(socket));
    }
  }

  int port = 1234;

  static final Controller _controller = Controller._internal();

  factory Controller() {
    return _controller;
  }

  Controller._internal();
}
