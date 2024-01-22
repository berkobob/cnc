import 'dart:async';
import 'dart:io';

import 'package:cnc/model/machine_model.dart';

import '../services/log.dart';

class Controller {
  Stream<Machine> get stream async* {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    log.info('Server runnig on ${server.address}');
    await for (Socket socket in server) {
      yield Machine(socket);
    }
  }

  final int port;
  Controller([this.port = 1234]);
}
