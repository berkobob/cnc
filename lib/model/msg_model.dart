class Msg {
  String name;
  double temp;
  String os;
  double clock;
  int throttle;
  double uptime;
  double idle;
  String cpu;
  String mem;
  String address;

  Msg(Map<String, dynamic> data)
      : name = data['name'],
        temp = double.parse(data['temp']),
        os = data['os'],
        clock = double.parse(data['clock']),
        throttle = int.parse(data['throttle']),
        uptime = double.parse(data['uptime']),
        idle = double.parse(data['idle']),
        cpu = data['cpu'],
        mem = data['mem'],
        address = data['address'] {
    final int memString = int.parse(mem);
    mem = '${(memString / 1000000).round()}M';
    clock = clock / 100000000;
  }

  @override
  String toString() =>
      'Name: $name, Temp: $temp, OS: $os, CPU: $cpu, MEM: $mem, Clock: $clock, Throttle: $throttle, Uptime: $uptime, Idle: $idle';
}
