class Msg {
  String name;
  String temp;
  String os;
  int clock;
  int throttle;
  double uptime;
  double idle;
  String cpu;
  String mem;

  Msg(Map<String, dynamic> data)
      : name = data['name'],
        temp = data['temp'],
        os = data['os'],
        clock = int.parse(data['clock']),
        throttle = int.parse(data['throttle']),
        uptime = double.parse(data['uptime']),
        idle = double.parse(data['idle']),
        cpu = data['cpu'],
        mem = data['mem'] {
    final int memString = int.parse(mem);
    mem = '${(memString / 1000000).round()}M';
  }

  @override
  String toString() =>
      'Name: $name, Temp: $temp, OS: $os, CPU: $cpu, MEM: $mem, Clock: $clock, Throttle: $throttle, Uptime: $uptime, Idle: $idle';
}
