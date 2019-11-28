import 'dart:async';

import 'package:ble_flt/sdk/ble_cmd_api.dart';
import 'package:ble_flt/sdk/ble_looptask.dart';

import 'ble_callback.dart';
import 'ble_constants.dart';

const STEP_BIND_OK = 1;
const STEP_READ_DEVICE_INFO = 2;
const STEP_SET_TIME = 3;
const STEP_SET_USERINFO = 4;
const STEP_IDLE = 5;

class MegaBleResponseManager {
  final MegaCmdApiManager apiManager;
  final MegaCallback callback;
  LoopTaskManager _loopTaskManager;
  int _stepCounter = 0;

  MegaBleResponseManager(this.apiManager, this.callback);

  void handleIndicateResponse(List<int> a) {
    int cmd = a[0], status = a[2];
    switch (cmd) {
      case CMD_FAKEBIND:
        if (status == 0) {
          switch (a[3]) {
            case 0:  // receive token
              callback.onTokenReceived(List.of([a[4], a[5], a[6], a[7], a[8], a[9]]).join(','));
              break;
            case 1:  // already bound
              _nextStep();
              break;
            case 2:  // please alert user to knock device
              callback.onKnockDevice();
              break;
            case 3:  // low power
              callback.onOperationStatus(cmd, STATUS_LOWPOWER);
              break;
            case 4:  // userInfo not match
              callback.onEnsureBindWhenTokenNotMatch();
              break;
              
            default:
              callback.onError(ERROR_BIND);
              break;
          }
        }

        break;
      default:
    }
  }

  void handleNotifyResponse(List<int> a) {

  }

  void _nextStep() {
    _stepCounter++;

    switch (_stepCounter) {
      case STEP_BIND_OK:
        _loopTaskManager = LoopTaskManager(onSendHeartBeat: this.apiManager.sendHeartBeat);
        break;
      default:
    }
  }

}

