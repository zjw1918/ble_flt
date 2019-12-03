class MegaV2Mode {
  const MegaV2Mode(this.mode, this.duration);
  final int mode;
  final int duration;

  @override
  String toString() {
    return 'MegaV2Mode{ mode:${this.mode}, duration:${this.duration} }';
  }
}

class MegaBleHeartBeat {
  const MegaBleHeartBeat(
    this.version,
    this.battPercent,
    this.deviceStatus,
    this.mode,
    this.recordStatus,
    this.periodMonitorStatus,
  );
  final int version;
  final int battPercent;
  final int deviceStatus;
  final int mode;
  final int recordStatus;
  final int periodMonitorStatus;

  @override
  String toString() {
    return 'MegaBleHeartBeat{ version:${this.version}, battPercent:${this.battPercent}, deviceStatus:${this.deviceStatus}, mode:${this.mode}, recordStatus:${this.recordStatus}, periodMonitorStatus:${this.periodMonitorStatus} }';
  }
}

class MegaV2Live {
  const MegaV2Live({this.spo, this.pr, this.status, this.duration});
  final int spo;
  final int pr;
  final int status;
  final int duration;

  @override
  String toString() {
    return 'MegaV2Live{ spo:${this.spo}, pr:${this.pr}, status:${this.status}, duration:${this.duration} }';
  }
}
