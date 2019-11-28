import 'dart:convert';
import 'package:ble_flt/sdk/ble_constants.dart';
import 'package:ble_flt/sdk/ble_util.dart';

class CmdMaker {
  static int statusClient = STATUS_CLIENT_ANDROID;

  static List<int> makeBindMasterPackage() {
    var s = BleUtil.genRandomString(12);
    return _initPack(CMD_FAKEBIND)
      ..setRange(3, 15, utf8.encode(s))
      ..setRange(15, 20, BleUtil.generateMd5(s).bytes);
  }

  static List<int> makeHeartBeatCmd() => _initPackWithArg(CMD_HEARTBEAT, 1);

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

  static makeV2EnableModeSpoMonitor(bool ensure, int time) {
    return _initPack(CMD_V2_MODE_SPO_MONITOR)
        ..[1] =  CMD_V2_MODE_SPO_MONITOR // 兼容陶瓷戒指
        ..[3] =  (ensure ? 'S'.codeUnitAt(0) : 0)
        ..[4] =  ((time & 0xff000000) >> 24)
        ..[5] =  ((time & 0x00ff0000) >> 16)
        ..[6] =  ((time & 0x0000ff00) >> 8)
        ..[7] =  (time & 0x000000ff);
  }

  /// help fn
  static List<int> _initPack(int cmd) {
    return List.filled(20, 0)
      ..[0] = cmd
      ..[1] = 0
      ..[2] = statusClient;
  }

  static List<int> _initPackWithArg(int cmd, int arg) {
    return _initPack(cmd)..[3] = arg;
  }
}
