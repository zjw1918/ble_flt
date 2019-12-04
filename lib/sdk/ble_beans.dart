import 'ble_constants.dart';

class MegaV2Mode {
  const MegaV2Mode(this.mode, this.duration);
  final int mode;
  final int duration;

  @override
  String toString() {
    return 'MegaV2Mode{ mode:$mode, duration:$duration }';
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
    return 'MegaBleHeartBeat{ version:$version, battPercent:$battPercent, deviceStatus:$deviceStatus, mode:$mode, recordStatus:$recordStatus, periodMonitorStatus:$periodMonitorStatus }';
  }
}

class MegaV2Live {
  const MegaV2Live({this.spo, this.pr, this.status, this.duration, this.mode});
  final int spo;
  final int pr;
  final int status;
  final int duration;
  final int mode;

  @override
  String toString() {
    return 'MegaV2Live{ spo:$spo, pr:$pr, status:$status, duration:$duration, mode:$mode }';
  }
}

class MegaDeviceInfo {
  MegaDeviceInfo({
    this.name,
    this.mac,
    this.otherInfo,
    this.hwVer,
    this.fwVer,
    this.blVer,
    this.sn,
    this.isRunning,
    this.rawSn,
    this.rawHwSwBl,
    this.batt,
  });
  String name;
  String mac;
  String otherInfo;

  String hwVer;
  String fwVer;
  String blVer;
  String sn;
  bool isRunning;

  List<int> rawSn; // 附件原始sn字节
  List<int> rawHwSwBl; // 固件原始信息字节

  MegaBattery batt;

  @override
  String toString() {
    return 'MegaDeviceInfo{ name: $name, mac: $mac, otherInfo: $otherInfo, hwVer: $hwVer, fwVer: $fwVer, blVer: $blVer, sn: $sn, isRunning: $isRunning, rawSn: $rawSn, rawHwSwBl: $rawHwSwBl, batt:$batt }';
  }
}

class MegaBattery {
  MegaBattery(this.value, this.status, this.duration);
  final int value;
  final int status;
  final int duration;

  @override
  String toString() {
    var _status = CONST_BATTERY_DESC[status];
    return 'value:$value, status:$_status, duration:$duration';
  }
}