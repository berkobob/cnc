import 'package:flutter/material.dart';

import 'services/scroll_behaviour.dart';
import 'view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Map<String, dynamic> json = const {
    'name': 'icetower',
    'temp': '32.6C',
    'os': 'Debian GNU/Linux 12 (bookworm)',
    'cpu': 'Raspberry Pi 4 Model B Rev 1.1',
    'mem': '4010010',
    'clock': '700154304',
    'throttle': '524288',
    'uptime': '1363446.06',
    'idle': '5444603.29',
    'address': '192.168.1.333'
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      title: 'Command and Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Container(
          margin: const EdgeInsets.fromLTRB(127.0, 26.0, 127.0, 93.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: const HomePage()),
    );
  }
}
