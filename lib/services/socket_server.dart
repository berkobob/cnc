import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

import '../model/device.dart';

final log = Logger('SocketServer');

class SocketServer {
  SocketServer([int port = 1234]) {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) async {
      _server = server;
      log.info('Server running on ${server.address.address}:$port');
    });
  }

  late final ServerSocket _server;

  Future<ServerSocket> close() async {
    return await _server.close();
  }

  Stream<Device> get stream async* {
    await for (final deviceSocket in _server) {
      yield Device(deviceSocket);
    }
  }
}
