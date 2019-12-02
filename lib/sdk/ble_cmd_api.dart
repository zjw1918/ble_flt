import 'package:convert/convert.dart';

import 'ble_client.dart';
import 'ble_cmd_maker.dart';
import 'ble_service.dart';

class MegaCmdApiManager {
  final BleService service;
  Map<int, Function(int, dynamic, [dynamic])> cmdMap = {};

  MegaCmdApiManager({this.service});

  initPipes() async {
    await this.service.chIndi.setNotifyValue(true);
    await this.service.chNoti.setNotifyValue(true);
  }

  void bindWithMasterToken(BleFunc fn) {
    var a = CmdMaker.makeBindMasterCmd();
    this.cmdMap[a[1]] = fn;
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }

  void sendHeartBeat([BleFunc fn]) {
    var a = CmdMaker.makeHeartBeatCmd();
    if (fn != null) this.cmdMap[a[1]] = fn;
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }

  void readRssi() {

  }

  void setTime([BleFunc fn]) {
    var a = CmdMaker.makeSetTimeCmd();
    if (fn != null) this.cmdMap[a[1]] = fn;
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }

  void setUserInfo(int age, int gender, int height, int weight, int stepLength, [BleFunc fn]) {
    var a = CmdMaker.makeUserInfoCmd(age, gender, height, weight, stepLength);
    if (fn != null) this.cmdMap[a[1]] = fn;
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }

  Future<List<int>> readDeviceInfo() {
    return this.service.chRead.read();
  }


}
