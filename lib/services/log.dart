import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void logging() {
  Logger.root.level = Level.FINEST; // defaults to Level.INFO

  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.loggerName}: ${record.message}');
  });
}
