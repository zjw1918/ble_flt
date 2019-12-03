import 'package:convert/convert.dart';

import 'ble_client.dart';
import 'ble_cmd_maker.dart';
import 'ble_service.dart';

class MegaCmdApiManager {
  final BleService service;
  MegaCmdApiManager({this.service});

  initPipes() async {
    await this.service.chIndi.setNotifyValue(true);
    await this.service.chNoti.setNotifyValue(true);
  }

  void bindWithMasterToken() {
    var a = CmdMaker.makeBindMasterCmd();
    if (BleConfig.debuggable) print('[cmd->] bindWithMasterToken: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void sendHeartBeat() {
    var a = CmdMaker.makeHeartBeatCmd();
    if (BleConfig.debuggable) print('[cmd->] sendHeartBeat: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void readRssi() {

  }

  void setTime() {
    var a = CmdMaker.makeSetTimeCmd();
    if (BleConfig.debuggable) print('[cmd->] setTime: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void setUserInfo(int age, int gender, int height, int weight, int stepLength) {
    var a = CmdMaker.makeUserInfoCmd(age, gender, height, weight, stepLength);
    if (BleConfig.debuggable) print('[cmd->] setUserInfo: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  Future<List<int>> readDeviceInfo() {
    return this.service.chRead.read();
  }


}
