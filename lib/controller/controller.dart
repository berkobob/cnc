import 'dart:io';

import 'package:cnc/model/machine_model.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final log = Logger('Controller');

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
        final int index = machines.indexWhere((machine) =>
            machine.socket.remoteAddress.address ==
            socket.remoteAddress.address);

        if (index == -1) {
          machines.add(Machine(socket,
              alert:
                  'A new machine is joining the party from ${socket.remoteAddress.address}'));
        } else {
          final name = machines[index].lastMsg?.name;
          machines.removeAt(index);
          machines.insert(index,
              Machine(socket, alert: 'Good news. $name is back with us'));
        }
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
