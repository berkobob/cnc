import 'dart:io';

import '../services/json_converter.dart';
import '../services/log.dart';

class Machine {
  final Socket socket;
  String address = '';
  Stream get stream => socket.transform(JsonConverter());
  Machine(this.socket) {
    address = socket.remoteAddress.address;
    log.info('A new machine has connected from ${socket.remoteAddress}');
  }
}
