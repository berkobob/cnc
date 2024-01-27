import 'dart:io';

import 'package:cnc/model/machine_model.dart';
import 'package:flutter/foundation.dart';

import '../services/log.dart';

class Controller extends ChangeNotifier {
  final List<Machine> machines = List.empty(growable: true);

  static final Controller _controller = Controller._internal();

  factory Controller() {
    return _controller;
  }

  Controller._internal() {
    ServerSocket.bind(InternetAddress.anyIPv4, 1234, shared: false)
        .then((server) async {
      log.info('Server running on ${server.address}');
      server.listen((socket) {
        try {
          final Machine machine = machines.firstWhere((machine) =>
              machine.socket.remoteAddress.address ==
              socket.remoteAddress.address);
          machines.remove(machine);
        } catch (_) {}
        machines.add(Machine(socket));
        notifyListeners();
      });
    });
  }

  void kill(Machine machine) {
    machines.remove(machine);
    machine.socket.close();
    notifyListeners();
  }
}
