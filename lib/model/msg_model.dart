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
    print(throttle);
    if (throttle & 0x1 != 0) {
      print('Under-voltage detected!');
    }
    if (throttle & 0x2 != 0) {
      print('Arm frequency capped!');
    }
    if (throttle & 0x4 != 0) {
      print('Currently throttled!');
    }
    if (throttle & 0x8 != 0) {
      print('Soft temperature limit active!');
    }
    if (throttle & 0x80 != 0) {
      print('Under-voltage has occurred since last reboot!');
    }
    if (throttle & 0x100 != 0) {
      print('Throttling has occurred since last reboot!');
    }
    if (throttle & 0x200 != 0) {
      print('Arm frequency capped has occurred since last reboot!');
    }
    if (throttle & 0x400 != 0) {
      print('Soft temperature limit has occurred since last reboot!');
    }
  }

  ThrottleState get voltage => throttle & 0x1 != 0
      ? ThrottleState.now
      : throttle & 0x80 != 0
          ? ThrottleState.previously
          : ThrottleState.none;

  ThrottleState get frequency => throttle & 0x2 != 0
      ? ThrottleState.now
      : throttle & 0x200 != 0
          ? ThrottleState.previously
          : ThrottleState.none;

  ThrottleState get overheat => throttle & 0x8 != 0
      ? ThrottleState.now
      : throttle & 0x400 != 0
          ? ThrottleState.previously
          : ThrottleState.none;

  String get idleText => ((uptime - idle) / uptime * 100).toStringAsFixed(1);

  (String, String) get uptimeText => uptime < 60
      ? ('${uptime.round()}', 'secs')
      : uptime < 3600 // = an hour
          ? ('${(uptime / 60).round()}', 'mins')
          : uptime < 86400 // = a day
              ? ('${(uptime / 3600).round()}', 'hrs')
              : uptime < 604800 // = a week
                  ? ('${(uptime / 3600).round()}', 'days')
                  : uptime < 2628000
                      ? ('${(uptime / 604800).round()}', 'wks')
                      : ('${(uptime / 2628000).round()}', 'mnths');

  @override
  String toString() =>
      'Name: $name, Temp: $temp, OS: $os, CPU: $cpu, MEM: $mem, Clock: $clock, Throttle: $throttle, Uptime: $uptime, Idle: $idle';
}

enum ThrottleState { none, now, previously }
