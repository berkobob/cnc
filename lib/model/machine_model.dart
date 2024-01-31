import 'dart:io';

import 'package:logging/logging.dart';

import '../services/json_converter.dart';
import 'msg_model.dart';

final log = Logger('Machine');

class Machine {
  Socket socket;
  Msg? lastMsg;
  String? alert;

  Stream get stream => socket.asBroadcastStream().transform(JsonConverter());

  Machine(this.socket, {this.alert}) {
    log.info('A new machine has connected from ${socket.remoteAddress}');
  }

  void shutdown() {
    log.shout('Shutting down ${lastMsg!.name}');
    socket.writeln('A command has come from control to shutdown now');
    log.severe('Running: ssh ${'-t '
        'pi@${lastMsg!.name}.local '
        'sudo poweroff'}');
    Process.run('ssh', ['-t', 'pi@${lastMsg!.name}.local', 'sudo poweroff']);
  }

  @override
  String toString() => '${socket.remoteAddress.address}\t ${lastMsg?.name}';
}
