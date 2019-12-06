import 'package:convert/convert.dart';

import 'ble_beans.dart';
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
    if (BleConfig.debuggable)
      print('[cmd->] bindWithMasterToken: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void sendHeartBeat() {
    var a = CmdMaker.makeHeartBeatCmd();
    if (BleConfig.debuggable) print('[cmd->] sendHeartBeat: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void readRssi() {}

  void setTime() {
    var a = CmdMaker.makeSetTimeCmd();
    if (BleConfig.debuggable) print('[cmd->] setTime: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void setUserInfo(
      int age, int gender, int height, int weight, int stepLength) {
    var a = CmdMaker.makeUserInfoCmd(age, gender, height, weight, stepLength);
    if (BleConfig.debuggable) print('[cmd->] setUserInfo: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  Future<List<int>> readDeviceInfo() {
    return this.service.chRead.read();
  }

  /// enbale global live
  void toggleLive(bool enable) {
    var a = CmdMaker.makeLiveCmd(enable);
    if (BleConfig.debuggable) print('[cmd->] toggleLive: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  /// enable spo
  void enableV2ModeSpo(bool ensure, int seconds) {
    var a = CmdMaker.makeV2EnableModeSpo(ensure, seconds);
    if (BleConfig.debuggable)
      print('[cmd->] enableV2ModeSpo: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  /// enable sport
  void enableV2ModeSport(bool ensure, int seconds) {
    var a = CmdMaker.makeV2EnableModeSport(ensure, seconds);
    if (BleConfig.debuggable)
      print('[cmd->] enableV2ModeSport: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  /// enable daily / stop monitor
  void enableV2ModeDaily(bool ensure, int seconds) {
    var a = CmdMaker.makeV2EnableModeDaily(ensure, seconds);
    if (BleConfig.debuggable)
      print('[cmd->] enableV2ModeDaily: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  /// sync data
  void syncMonitorData() {
    var a = CmdMaker.makeSyncMonitorDataCmd();
    if (BleConfig.debuggable)
      print('[cmd->] syncMonitorData: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void syncDailyData() {
    var a = CmdMaker.makeSyncDailyDataCmd();
    if (BleConfig.debuggable) print('[cmd->] syncDailyData: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }

  void writePack(List<int> a) {
    if (BleConfig.debuggable) print('[cmd->] writePack: ' + hex.encode(a));
    this.service.chWrite.write(a);
  }
}
