import 'dart:convert';
import 'package:ble_flt/sdk/ble_constants.dart';
import 'package:ble_flt/sdk/ble_util.dart';

const STATUS_CLIENT = STATUS_CLIENT_ANDROID;

class CmdMaker {
  static int _snCount = 0;

  static List<int> makeBindMasterCmd() {
    var s = BleUtil.genRandomString(12);
    return _initPack(CMD_FAKEBIND)
      ..setRange(3, 15, utf8.encode(s))
      ..setRange(15, 20, BleUtil.generateMd5(s).bytes);
  }

  static List<int> makeHeartBeatCmd() => _initPack(CMD_HEARTBEAT, arg: 1);

  static List<int> makeSetTimeCmd() {
    int t = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _initPack(CMD_SETTIME)
      ..[3] = (t & 0xff000000) >> 24
      ..[4] = (t & 0x00ff0000) >> 16
      ..[5] = (t & 0x0000ff00) >> 8
      ..[6] = (t & 0x000000ff);
  }

  static List<int> makeUserInfoCmd(
      int age, int gender, int height, int weight, int stepLength) {
    return _initPack(CMD_SETUSERINFO)
      ..[3] = age // age 25
      ..[4] = gender // gender 0/1
      ..[5] = height // height 170
      ..[6] = weight // weight 60
      ..[7] = stepLength; // step length 0
  }

  static List<int> makeV2EnableModeSpoMonitor(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_SPO_MONITOR)
      ..[3] = (ensure ? 'S'.codeUnitAt(0) : 0)
      ..setRange(4, 8, timeToBytes(time));
  }

  static List<int> makeV2EnableModeEcgBp(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_ECG_BP)
      ..[3] = (ensure ? 'S'.codeUnitAt(0) : 0)
      ..setRange(4, 8, timeToBytes(time));
  }

  static List<int> makeV2EnableModeSport(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_SPORT)
      ..[3] = (ensure ? 'S'.codeUnitAt(0) : 0)
      ..setRange(4, 8, timeToBytes(time));
  }

  static List<int> makeV2EnableModeDaily(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_DAILY)
      ..[3] = (ensure ? 'S'.codeUnitAt(0) : 0)
      ..setRange(4, 8, timeToBytes(time));
  }

  static List<int> makeV2EnableModeLiveSpo(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_LIVE_SPO)
      ..[3] = (ensure ? 'S'.codeUnitAt(0) : 0)
      ..setRange(4, 8, timeToBytes(time));
  }

  static List<int> makeEnsureBind(bool ensure) => _initPack(CMD_FAKEBIND,
      arg: ensure ? 'Y'.codeUnitAt(0) : 'N'.codeUnitAt(0));

  /// sync data
  static List<int> makeSyncMonitorDataCmd() =>
      _initPack(CMD_SYNCDATA, arg: CTRL_MONITOR_DATA);
  static List<int> makeSyncDailyDataCmd() =>
      _initPack(CMD_SYNCDATA, arg: CTRL_DAILY_DATA);

  /// help fn
  static List<int> _initPack(int cmd, {int arg = 0}) => List.filled(20, 0)
    ..[0] = cmd
    ..[1] = _snCount++ & 0xff
    ..[2] = STATUS_CLIENT_ANDROID
    ..[3] = arg;
}

List<int> timeToBytes(int time) => [
      ((time & 0xff000000) >> 24),
      ((time & 0x00ff0000) >> 16),
      ((time & 0x0000ff00) >> 8),
      (time & 0x000000ff)
    ];
