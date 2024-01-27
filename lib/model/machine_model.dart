import 'dart:io';

import '../services/json_converter.dart';
import '../services/log.dart';
import 'msg_model.dart';

class Machine {
  Socket socket;
  Msg? lastMsg;
  Stream get stream => socket.transform(JsonConverter());
  Machine(this.socket) {
    log.info('A new machine has connected from ${socket.remoteAddress}');
  }

  @override
  String toString() => '${socket.remoteAddress.address}\t ${lastMsg?.name}';
}
