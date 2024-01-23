import 'package:flutter/material.dart';

import '../model/msg_model.dart';
import 'clock.dart';
import 'temp.dart';
import 'uptime.dart';

class MachineWidget extends StatelessWidget {
  const MachineWidget(this.msg, {super.key});
  final Msg msg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 5.0,
              blurRadius: 2.5,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.computer),
              const Spacer(flex: 1),
              Column(
                children: [
                  Text(
                    msg.name,
                    textScaler: const TextScaler.linear(1.5),
                  ),
                  Text(msg.address),
                ],
              ),
              const Spacer(flex: 2),
              const Row(children: [
                Icon(Icons.power, color: Colors.red),
                Icon(Icons.thermostat, color: Colors.yellow),
                Icon(Icons.access_time, color: Colors.green)
              ])
            ],
          ),
          Column(children: [
            Text(msg.os, maxLines: 1, overflow: TextOverflow.clip),
            Text(msg.cpu, maxLines: 1, overflow: TextOverflow.fade)
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Temp(msg.temp),
              Clock(msg.clock),
              const Uptime(),
            ],
          ),
          // Text(
          //   'Is there another row',
          //   textScaler: TextScaler.linear(1.17),
          // )
        ],
      ),
    );
  }
}
