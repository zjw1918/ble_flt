import 'package:ble_flt/sdk/ble_util.dart';

import 'ble_beans.dart';
import 'ble_sync_data.dart';
import 'ble_cmd_api.dart';
import 'ble_looptask.dart';
import 'ble_callback.dart';
import 'ble_constants.dart';

import 'package:convert/convert.dart';

const STEP_BIND_OK = 1;
const STEP_READ_DEVICE_INFO = 2;
const STEP_SET_TIME = 3;
const STEP_SET_USERINFO = 4;
const STEP_IDLE = 5;

class MegaBleResponseManager {
  final MegaCmdApiManager apiManager;
  final MegaCallback callback;
  MegaDeviceInfo _info;
  LoopTaskManager _loopTaskManager;
  MegaBleSyncDataManager _syncDataManager;

  int _stepCounter = 0;

  MegaBleResponseManager(this.apiManager, this.callback);

  void handleIndicateResponse(List<int> a) {
    if (a.isEmpty) return;
    int cmd = a[0], sn = a[1], status = a[2];
    print('[onIndicate<-] ${hex.encode(a)}');
    switch (cmd) {
      case CMD_FAKEBIND:
        if (status == 0) {
          switch (a[3]) {
            case 0: // receive token
              callback.onTokenReceived(
                  List.of([a[4], a[5], a[6], a[7], a[8], a[9]]).join(','));
              _nextStep();
              break;
            case 1: // already bound
              _nextStep();
              break;
            case 2: // please alert user to knock device
              callback.onKnockDevice();
              break;
            case 3: // low power
              callback.onOperationStatus(cmd, STATUS_LOWPOWER);
              break;
            case 4: // userInfo not match
              callback.onEnsureBindWhenTokenNotMatch();
              break;
            default:
              callback.onError(STATUS_BOUND_ERROR);
              break;
          }
        }
        break;

      case CMD_SETTIME:
        if (status == 0) {
          int t = (a[3] << 24) | (a[4] << 16) | (a[5] << 8) | a[6];
          var d = DateTime.fromMillisecondsSinceEpoch(t * 1000);
          print('time set ok: $d');
        }
        _nextStep();
        break;

      case CMD_SETUSERINFO:
        _nextStep();
        break;

      case CMD_LIVECTRL:
      case CMD_FINDME:
      case CMD_MONITOR: // CMD_V2_MODE_SPO_MONITOR
      case CMD_V2_MODE_ECG_BP:
      case CMD_V2_MODE_SPORT:
      case CMD_V2_MODE_DAILY:
      case CMD_V2_MODE_LIVE_SPO:
        callback.onOperationStatus(cmd, status);
        break;

      case CMD_CRASHLOG:
        callback.onCrashLogReceived(a);
        break;

      case CMD_V2_GET_MODE:
        if (status == 0) {
          int duration = (a[3] == 1 || a[3] == 2)
              ? ((a[4] << 24) | (a[5] << 16) | (a[6] << 8) | a[7])
              : 0;
          callback.onV2ModeReceived(MegaV2Mode(a[3], duration));
        }
        break;

      case CMD_SYNCDATA:
        callback.onOperationStatus(cmd, status);
        if (status == 0) {
          print('Trans permission [yes]...');
          _syncDataManager = MegaBleSyncDataManager(SyncDataCallback(
            onWriteReportPack: (List<int> pack) {
              apiManager.writePack(pack);
            },
            onProgress: (progress) {
              callback.onSyncingDataProgress(progress);
            },
            onDailyDataComplete: (List<int> bytes) {
              callback.onSyncDailyDataComplete(bytes);
            },
            onMonitorDataComplete: (List<int> bytes, int dataStopType, int dataType, String uid) {
              callback.onSyncMonitorDataComplete(bytes, dataStopType, dataType, uid);
            },
            onSyncDailyData: () {
              apiManager.syncDailyData();
            },
            onSyncMonitorData: () {
              apiManager.syncMonitorData();
            }
          ));
          _syncDataManager.info = _info;
          _syncDataManager.handleTransmitPermitted(a);
        } else {
          _syncDataManager = null;
          if (status == 2) {
            print('Trans permission [no], no data.');
            if (a[5] == 0 || a[5] == CTRL_DAILY_DATA) {
              print('No daily data.');
              callback.onSyncNoDataOfDaily();
            } else if (a[5] == CTRL_MONITOR_DATA) {
              print('No monitor data.');
              callback.onSyncNoDataOfMonitor();
            }
          }
        }
        break;

      case CTRL_MONITOR_DATA:
      case CTRL_DAILY_DATA:
        _syncDataManager?.handleCtrlIndicate(a);
        break;

      case CMD_NOTIBATT:
        callback.onBatteryChangedV2(MegaBattery(a[3], a[4], (a[5] << 16) | (a[6] << 8) | a[7]));
        break;

      case CMD_HEARTBEAT:
        callback.onHeartBeatReceived(
            MegaBleHeartBeat(a[3], a[4], a[5], a[6], a[7], a[8]));
        break;

      default:
    }
  }

  void handleNotifyResponse(List<int> a) {
    print('handleNotifyResponse: ${hex.encode(a)}');
    if (a.isEmpty) return;
    int cmd = a[0];

    switch (cmd) {
      case CMD_LIVECTRL:
        _dispatchV2Live(a);
        break;
      case CMD_NOTIBATT:
        callback.onBatteryChangedV2(MegaBattery(a[3], a[4],
            ((a[5] & 0xff) << 16) | ((a[6] & 0xff) << 8) | (a[7] & 0xff)));
        break;

      default:
        _syncDataManager?.handleNotify(a);
    }
  }

  // void handleReadResponse(List<int> a) {
  //   print('read: $a');
  //   _nextStep();
  // }

  void handleDisConnect() {
    if (_loopTaskManager != null) {
      _loopTaskManager.clearLoops();
      _loopTaskManager = null;
    }
  }

  void _nextStep() async {
    _stepCounter++;

    switch (_stepCounter) {
      case STEP_BIND_OK:
        _loopTaskManager =
            LoopTaskManager(this.apiManager.sendHeartBeat, () {});
        _nextStep();
        break;

      case STEP_READ_DEVICE_INFO:
        var readInfo = await apiManager.readDeviceInfo();
        this._info = UtilBle.parseReadData(readInfo);
        print(this._info);
        callback.onDeviceInfoReceived(this._info);
        _nextStep();
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

  void _dispatchV2Live(List<int> a) {
    if (callback != null) {
      switch (a[2]) {
        case 0:
          callback.onV2Live(MegaV2Live(
              mode: a[2],
              spo: a[3],
              pr: a[4],
              status: a[5])); // spo, hr, flag | a[3]  a[4] a[5]
          break;
        case 1:
          callback.onV2Live(MegaV2Live(
              mode: a[2],
              status: a[3],
              spo: a[4],
              pr: a[5],
              duration: (a[6] << 24) | (a[7] << 16) | (a[8] << 8) | a[9]));
          break;
        case 2:
          callback.onV2Live(MegaV2Live(
              mode: a[2],
              status: a[3],
              pr: a[4],
              duration: (a[5] << 24) | (a[6] << 16) | (a[7] << 8) | a[8]));
          break;
        case 3:
          break;
        case 4:
          callback.onV2Live(
              MegaV2Live(mode: a[2], status: a[3], spo: a[4], pr: a[5]));
          break;

        default:
      }
    }
  }
}
