import 'package:flutter/material.dart';

import '../model/msg_model.dart';
import 'clock.dart';
import 'temp.dart';
import 'throttling.dart';
import 'uptime.dart';

class MachineWidget extends StatelessWidget {
  const MachineWidget(this.msg, {this.inactive = false, super.key});
  final Msg msg;
  final bool inactive;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: inactive
          ? const BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.saturation,
            )
          : null,
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
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          const Icon(Icons.computer),
          const Spacer(flex: 1),
          Column(children: [
            Text(
              msg.name,
              style:
                  const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(msg.address),
              const Text('\t'),
              Text(msg.mem),
            ]),
          ]),
          const Spacer(flex: 2),
          Throttling(
              frequency: msg.frequency,
              overheat: msg.overheat,
              voltage: msg.voltage)
        ]),
        Column(children: [
          Text(msg.os, maxLines: 1, overflow: TextOverflow.clip),
          Text(msg.cpu, maxLines: 1, overflow: TextOverflow.fade)
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Temp(msg.temp),
              Uptime(
                msg.uptimeText,
              ),
              Clock(msg.clock),
            ]),
      ]),
    );
  }
}
