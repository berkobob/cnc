import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import '../model/msg_model.dart';

class JsonConverter extends StreamTransformerBase<Uint8List, Msg> {
  @override
  Stream<Msg> bind(Stream<Uint8List> stream) async* {
    await for (final data in stream) {
      final Map<String, dynamic> json = jsonDecode(String.fromCharCodes(data));
      yield Msg(json);
    }
  }
}
