import 'dart:async';

import 'ble_service.dart';
import 'constants.dart';

class MegaBleResponseManager {
  BleService service;
  Map<int, BleExecution> cmdMap = {};

  MegaBleResponseManager({this.service}) {

  }

  void handleIndicateResponse(List<int> a) {
    int cmd = a[0], status = a[2];
    switch (cmd) {
      case CMD_FAKEBIND:
        var exe = cmdMap[cmd];
        if (exe != null && exe.isActive) {
          exe.fn('ok', null);
        }
        break;
      default:
    }
  }

  void handleNotifyResponse(List<int> a) {

  }

  bindWithMasterToken(Function fn) async {
    var a = [1,2];
    var cmd = a[0];
    try {
      cmdMap[cmd] = BleExecution(fn);
      await service.chWrite.write(a);
    } catch (e) {
      cmdMap[cmd] = null;
      return Future.error(e);
    }
  }

  Future _registResponse(int cmd, fn) {
    cmdMap[cmd] = fn;
  }

}

