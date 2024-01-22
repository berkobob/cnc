import 'dart:io';

import '../services/json_converter.dart';
import '../services/log.dart';

class Machine {
  Socket socket;
  Stream get stream => socket.transform(JsonConverter());
  Machine(this.socket) {
    log.info('A new machine has connected from ${socket.remoteAddress}');
  }
}
