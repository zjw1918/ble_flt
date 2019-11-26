import 'ble_service.dart';
import 'constants.dart';

class MegaBleResponseManager {
  BleService service;
  Map<int, Function> cmdMap = {};

  MegaBleResponseManager({this.service}) {

  }

  void handleIndicateResponse(List<int> a) {
    int cmd = a[0], status = a[2];
    switch (cmd) {
      case CMD_FAKEBIND:
        var fn = cmdMap[cmd];
        if (fn != null) {
          fn(a);
        }
        break;
      default:
    }
  }

  void handleNotifyResponse(List<int> a) {

  }

  Future<Null> bindWithMasterToken(Function fn) async {
    var a = [1,2];
    var cmd = a[0];
    try {
      var timeout = Future.delayed(Duration(seconds: 10));
      cmdMap[cmd] = (res, err, timeout) {
        
      };
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
