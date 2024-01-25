import 'package:flutter/material.dart';

class Uptime extends StatelessWidget {
  final (String, String) time;
  const Uptime(this.time, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time.$1,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          Text(time.$2,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
