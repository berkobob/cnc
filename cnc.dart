import 'dart:io';
import "dart:convert";

void main() async {
  Socket? socket;

  final payload = await init();

  while (socket == null) {
    socket = await connect();
    await Future.delayed(Duration(seconds: 5));
  }
  payload['address'] = socket.address.address;

  print('Connected to: '
      '${socket.remoteAddress.address}:${socket.remotePort}');

  while (true) {
    try {
      await buildPayload(payload);
      socket.write(json.encode(payload));
    } on SocketException catch (_) {
      print('CnC has stopped receiving data.');
      socket.destroy();
    } catch (error) {
      print('Failed to send payload: $error');
    }
    await Future.delayed(Duration(seconds: 20));
  }
}

Future<String> readUptime() async {
  try {
    final file = await File('/proc/uptime').readAsString();
    return file;
  } catch (e) {
    print('Error: $e');
  }
  return "";
}

Future<List<String>> readOs(String fileName) async {
  try {
    return (await File(fileName).readAsString()).split('\n');
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

bool nomsg = true;

Future<Socket?> connect() async {
  try {
    return await Socket.connect("macstudio.local", 1234);
  } on SocketException catch (e) {
    if (nomsg) {
      print('CNC not listening ${e.message}');
      nomsg = false;
    }
  } catch (e) {
    print('Something went wrong $e');
  }
  return null;
}

Future<Map<String, dynamic>> init() async {
  final name = Platform.localHostname;
  final rawOs = await readOs('/etc/os-release');
  final os = rawOs[0].split('=')[1].replaceAll('\"', '');
  final file = await readOs('/proc/cpuinfo');
  final cpu = file[file.length - 2].split(':')[1].trim();
  final file2 = await readOs('/proc/meminfo');
  final mem = file2[0].split(':')[1].trim().split(' ')[0];

  return {'name': name, 'os': os, 'cpu': cpu, 'mem': mem};
}

Future buildPayload(Map<String, dynamic> payload) async {
  List<Future> futures = [];

  futures.add(Process.run("vcgencmd", ["measure_temp"]));
  futures.add(Process.run("vcgencmd", ["measure_clock", "arm"]));
  futures.add(Process.run("vcgencmd", ["get_throttled"]));
  futures.add(readUptime());
  final result = await Future.wait(futures);

  payload['temp'] = result[0].stdout.trim().split('=')[1];
  payload['clock'] = result[1].stdout.trim().split('=')[1];
  payload['throttle'] = result[2].stdout.trim().split('=')[1];
  payload['uptime'] = result[3].trim().split(' ')[0];
  payload['idle'] = result[3].trim().split(' ')[1];
}
