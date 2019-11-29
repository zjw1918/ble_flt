import 'ble_beans.dart';
import 'ble_sync_data.dart';
import 'ble_cmd_api.dart';
import 'ble_looptask.dart';
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
  MegaBleSyncDataManager _syncDataManager;

  int _stepCounter = 0;

  MegaBleResponseManager(this.apiManager, this.callback);

  void handleIndicateResponse(List<int> a) {
    int cmd = a[0], sn = a[1], status = a[2];
    void Function(int, dynamic, [dynamic]) fn = apiManager.cmdMap[sn];
    if (fn == null)
      return print('No function found: cmd:$cmd, sn: $sn, status: $status');
    switch (cmd) {
      case CMD_FAKEBIND:
        if (status == 0) {
          switch (a[3]) {
            case 0: // receive token
              fn(a[3], List.of([a[4], a[5], a[6], a[7], a[8], a[9]]).join(','));
              _nextStep();
              break;
            case 1: // already bound
              fn(a[3], null);
              _nextStep();
              break;
            case 2: // please alert user to knock device
            case 3: // low power
            case 4: // userInfo not match
              fn(a[3], null);
              break;
            default:
              fn(STATUS_BOUND_ERROR, null);
              break;
          }
        }
        break;

      case CMD_SETTIME:
        if (status == 0)
          fn(status, (a[3] << 24) | (a[4] << 16) | (a[5] << 8) | a[6]);
        _clearCmdMap(sn);
        _nextStep();
        break;

      case CMD_SETUSERINFO:
        if (status == 0) fn(status, true);
        _clearCmdMap(sn);
        _nextStep();
        break;

      case CMD_LIVECTRL:
      case CMD_FINDME:
      case CMD_MONITOR: // CMD_V2_MODE_SPO_MONITOR
      case CMD_V2_MODE_ECG_BP:
      case CMD_V2_MODE_SPORT:
      case CMD_V2_MODE_DAILY:
      case CMD_V2_MODE_LIVE_SPO:
        fn(status, null);
        _clearCmdMap(sn);
        break;

      case CMD_CRASHLOG:
        fn(status, a);
        _clearCmdMap(sn);
        break;

      case CMD_V2_GET_MODE:
        if (status == 0) {
          int duration = (a[3] == 1 || a[3] == 2)
              ? ((a[4] << 24) | (a[5] << 16) | (a[6] << 8) | a[7])
              : 0;
          fn(status, MegaV2Mode(a[3], duration));
        } else {
          fn(status, null);
        }
        _clearCmdMap(sn);
        break;

      case CMD_SYNCDATA:
        break;

      case CTRL_MONITOR_DATA:
      case CTRL_DAILY_DATA:
        break;

      case CMD_NOTIBATT:
        fn(status, [a[3], a[4], (a[5] << 16) | (a[6] << 8) | a[7]]);
        break;

      case CMD_HEARTBEAT:
        fn(status, MegaBleHeartBeat(a[3], a[4], a[5], a[6], a[7], a[8]));
        break;

      default:
    }
  }

  void handleNotifyResponse(List<int> a) {
    int cmd = a[0];

    switch (cmd) {
      case CMD_LIVECTRL:
        _dispatchV2Live(a);
        break;
      case CMD_NOTIBATT:
        callback.onBatteryChangedV2(a[3], a[4],
            ((a[5] & 0xff) << 16) | ((a[6] & 0xff) << 8) | (a[7] & 0xff));
        break;

      default:
    }
  }

  void handleReadResponse(List<int> a) {
    print('read: $a');
    _nextStep();
  }

  void handleDisConnect() {
    if (_loopTaskManager != null) {
      _loopTaskManager.clearLoops();
      _loopTaskManager = null;
    }
  }

  void _nextStep() {
    _stepCounter++;

    switch (_stepCounter) {
      case STEP_BIND_OK:
        _loopTaskManager =
            LoopTaskManager(this.apiManager.sendHeartBeat, () {});
        _nextStep();
        break;

      case STEP_READ_DEVICE_INFO:
        apiManager.readDeviceInfo();
        break;

      case STEP_SET_TIME:
        apiManager.setTime();
        break;

      case STEP_SET_USERINFO:
        callback.onSetUserInfo();
        break;

      case STEP_IDLE:
        callback.onIdle();
        break;

      default:
    }
  }

  void _clearCmdMap(int sn) {
    this.apiManager.cmdMap.remove(sn);
  }

  void _dispatchV2Live(List<int> a) {
    if (callback != null) {
      switch (a[2]) {
        case 0:
          callback.onV2Live(MegaV2Live(
              spo: a[3],
              pr: a[4],
              status: a[5])); // spo, hr, flag | a[3]  a[4] a[5]
          break;
        case 0x01:
          callback.onV2Live(MegaV2Live(
              status: a[3],
              spo: a[4],
              pr: a[5],
              duration: (a[6] << 24) | (a[7] << 16) | (a[8] << 8) | a[9]));
          break;
        case 0x02:
          callback.onV2Live(MegaV2Live(
              status: a[3],
              pr: a[4],
              duration: (a[5] << 24) | (a[6] << 16) | (a[7] << 8) | a[8]));
          break;
        case 0x03:
          break;
        case 0x04:
          callback.onV2Live(MegaV2Live(status: a[3], spo: a[4], pr: a[5]));
          break;

        default:
      }
    }
  }
}
