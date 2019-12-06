import 'dart:async';

import 'package:ble_flt/sdk/ble_util_file.dart';

import 'ble_constants.dart';
import 'ble_util.dart';
import 'ble_beans.dart';

const int CRC_LEN = 2;
const int PAYLOAD_LEN = 19;
const DATA_PROTOCOL = 1;

const PATH_BIN_DATA = '/megaFlt/data';

/// synd data manager
class MegaBleSyncDataManager {
  final SyncDataCallback _syncDataCallback;

  List<int> _totalBytes = [];
  Map<int, List<int>> _subSnMap;

  int _totalLen;
  int _subLen;

  List<int> _mReportPack;
  List<int> _mReportPackMissPack;

  int _dataStopType;
  int _dataType;
  Prefix _prefix;

  MegaDeviceInfo info;

  MegaBleSyncDataManager(this._syncDataCallback);

  void handleTransmitPermitted(List<int> a) {
    this._dataStopType = a[4];
    this._dataType = a[6];
    if (info != null) {
      _prefix = Prefix(
          [a[3], a[6], DATA_PROTOCOL, 0],
          _dataStopType,
          info.rawHwSwBl,
          info.rawSn,
          [a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15],a[16],a[17],a[18]]);
    }
  }

  void handleCtrlIndicate(List<int> a) {
    if (a[2] == 0) {
      // 一大包开始了
      _totalLen = (a[3] << 24) | (a[4] << 16) | (a[5] << 8) | (a[6]);
      _subLen = ((a[7] << 8) | a[8]);
      print('Total length: $_totalLen, sub length: $_subLen');
      _subSnMap = Map();
      _mReportPackMissPack = List.filled(16, 0);
    } else if (a[2] == 1) {
      // 一包传完了，开始检查，有无漏包
      int refNum = ((_subLen + CRC_LEN) / PAYLOAD_LEN).ceil();
      int missedNum = refNum - _subSnMap.length;
      _mReportPack = List.filled(20, 0)
        ..[0] = a[0]
        ..[1] = a[1];

      if (missedNum == 0) {
        // 无丢包
        _handleNoMiss(a);
      } else {
        // 有丢包
        _handleMiss(missedNum);
      }
    }
  }

  void handleNotify(List<int> a) {
    if (_mReportPackMissPack == null) {
      print(
          'Big data receive warning: Notify comes ahead of indicate, app_report_pack_misspart has not been initiated');
      return;
    }
    int sn = a[0] & 0xff;
    if (!_subSnMap.containsKey(sn)) {
      _subSnMap[sn] = a.sublist(1);
      _mReportPackMissPack[sn ~/ 8] |= 1 << (sn % 8);
    }
  }

  void _handleNoMiss(List<int> a) {
    List<int> rawSub = UtilBle.flatConcatMap(_subSnMap);
    List<int> sub = rawSub.sublist(0, _subLen);
    List<int> crcBytes = rawSub.sublist(_subLen, _subLen + 2);
    int bleCrc = (crcBytes[1] & 0xff) | (crcBytes[0] & 0xff) << 8;
    int myCrc = UtilBle.crcXmodem(sub);
    print('blecrc: $bleCrc, mycrc: $myCrc');
    if (myCrc == bleCrc) {
      // crc一致
      _mReportPack[2] = 1; // 1 ：续传；0：丢包重传、crc错误重传
      _syncDataCallback.onWriteReportPack(_mReportPack);

      // 将已收到的搜集起来
      _totalBytes += sub;
      if (_totalLen <= 0) return;

      int progress = _totalBytes.length * 100 ~/ _totalLen;
      _syncDataCallback.onProgress(progress);
      print('receiving data, progress $progress');

      if (_totalLen > 0 && _totalLen == _totalBytes.length) {
        // transmit complete
        List<int> finalBytes =
            _prefix.toBytes() + _totalBytes; // totalBytes 前增加解析协议号
        if (a[0] == CTRL_MONITOR_DATA) {
          if (BleConfig.debuggable)
            UtilFile.saveFile(PATH_BIN_DATA + '/' + UtilFile.getDataFileName(), finalBytes);
            // UtilsFile.saveDataToSD(finalBytes, UtilsFile.getDataFileName(), false); // save file for test

            _syncDataCallback.onMonitorDataComplete(
                finalBytes,
                this._dataStopType,
                this._dataType,
                _prefix.uidToString()); // 继续请求看ble有没有 运动/日常 数据了。
          Timer(
              Duration(milliseconds: 1200), _syncDataCallback.onSyncMonitorData);
        } else if (a[0] == CTRL_DAILY_DATA) {
          List<int> timestampBytes =
              UtilBle.intToBytes(DateTime.now().millisecondsSinceEpoch ~/ 1000);
          List<int> dailyBytes = timestampBytes + finalBytes;

          if (BleConfig.debuggable)
            UtilFile.saveFile(PATH_BIN_DATA + '/' + UtilFile.getDailyDataFileName(), finalBytes);
            // UtilsFile.saveDataToSD(dailyBytes, UtilsFile.getDailyDataFileName(), false); // save file for test

            _syncDataCallback.onDailyDataComplete(dailyBytes);
          Timer(Duration(milliseconds: 1200), _syncDataCallback.onSyncDailyData);
        }
      }
    } else {
      // crc不一致
      print('crc wrong!');
      _mReportPack[2] = 0;
      _mReportPack[3] = 0xff;
      _syncDataCallback.onWriteReportPack(_mReportPack);
    }
  }

  void _handleMiss(int miss) {
    _mReportPack[2] = 0;
    _mReportPack[3] = miss;
    _mReportPack.setRange(
        4, 4 + _mReportPackMissPack.length, _mReportPackMissPack);
    _syncDataCallback.onWriteReportPack(_mReportPack);
  }
}

/// sync data manager's SyncDataCallback
class SyncDataCallback {
  SyncDataCallback({
    this.onWriteReportPack,
    this.onProgress,
    this.onMonitorDataComplete,
    this.onDailyDataComplete,
    this.onSyncMonitorData,
    this.onSyncDailyData,
  });
  final void Function(List<int> pack) onWriteReportPack;
  final void Function(int progress) onProgress;
  final void Function(
          List<int> bytes, int dataStopType, int dataType, String uid)
      onMonitorDataComplete;
  final void Function(List<int> bytes) onDailyDataComplete;
  final void Function() onSyncMonitorData;
  final void Function() onSyncDailyData;
}

/// sync data manager's Prefix
class Prefix {
  final List<int> origin4;
  final int stopType;
  final List<int> hwswblBytes;
  final List<int> snBytes;
  final List<int> uidBytes;

  Prefix(this.origin4, this.stopType, this.hwswblBytes, this.snBytes,
      this.uidBytes);

  List<int> toBytes() {
    List<int> payload = [stopType, ...hwswblBytes, ...snBytes, ...uidBytes];
    return [...origin4, payload.length, ...payload];
  }

  String uidToString() =>
      uidBytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join('');
}
