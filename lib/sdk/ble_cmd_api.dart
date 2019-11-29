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

  void sendHeartBeat() {
    var a = CmdMaker.makeHeartBeatCmd();
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }

  void readRssi() {
    
  }

  void readDeviceInfo() {
    this.service.chRead.read();
  }

  void setTime() {
    var a = CmdMaker.makeSetTimeCmd();
    if (BleConfig.debuggable) print(hex.encode(a));
    this.service.chWrite.write(a);
  }
}
