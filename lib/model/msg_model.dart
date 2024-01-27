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
        throttle = int.parse(data['throttle'].substring(2), radix: 16),
        uptime = double.parse(data['uptime']),
        idle = double.parse(data['idle']),
        cpu = data['cpu'],
        mem = data['mem'],
        address = data['address'] {
    final int memString = int.parse(mem);
    mem = '${(memString / 1000000).round()}M';
    clock = clock / 100000000;
  }

  static const isVolts = 0x1;
  static const isFreq = 0x2;
  static const _isThrottled = 0x4;
  static const isHot = 0x8;
  static const wasVolts = 0x10000;
  static const wasFreq = 0x20000;
  static const _wasThrottled = 0x40000;
  static const wasHot = 0x80000;

  bool get isThrottled => throttle & _isThrottled == 0 ? false : true;
  bool get wasThrottled => throttle & _wasThrottled == 0 ? false : true;

  ThrottleState get voltage => throttle & wasVolts == 0
      ? ThrottleState.none
      : throttle & isVolts == 0
          ? ThrottleState.was
          : ThrottleState.now;

  ThrottleState get frequency => throttle & wasFreq == 0
      ? ThrottleState.none
      : throttle & isFreq == 0
          ? ThrottleState.was
          : ThrottleState.now;

  ThrottleState get overheat => throttle & wasHot == 0
      ? ThrottleState.none
      : throttle & isHot == 0
          ? ThrottleState.was
          : ThrottleState.now;

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

enum ThrottleState { none, now, was }
