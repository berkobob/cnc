import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final log = Logger('Log');

class Log {
  Log() {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
}
