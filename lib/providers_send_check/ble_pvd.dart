import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:ble_flt/pages/scan_drawer.dart';
import 'package:ble_flt/pages/send_check/ble_live_line_chart.dart';
import 'package:ble_flt/sdk/ble_constants.dart';

import 'package:ble_flt/sdk/ble_beans.dart';
import 'package:ble_flt/sdk/ble_callback.dart';
import 'package:ble_flt/sdk/ble_client.dart';


/// 图表里数据长度 100
const MAX_CHART_DATA_LENGTH = 100;

class BleProvider with ChangeNotifier {
  MegaBleClient client;
  BluetoothDevice _device;
  BuildContext _context;

  // dialog ui
  bool isShowingDialog = false;

  // notify properties
  MegaDeviceInfo info;
  MegaV2Live live;
  List<LivePoint> dataPr = genMockData();
  List<LivePoint> dataSpo = genMockData();

  // scan
  bool isScanning = false;
  List<ScanResult> _scanList = [];
  int _cnt = 0;

  // live animation
  AnimationController controller;

  static List<LivePoint> genMockData() {
    List<LivePoint> res = [];
    for (var i = 0; i < 100; i++) {
      res.add(LivePoint(i, null));
    }
    return res;
  }

  withContext(BuildContext context) {
    this._context = context;
  }

  void initWithDevice(BluetoothDevice device) {
    this._device = device;
    client = MegaBleClient(
        device: device,
        callback:
            MegaCallback(onConnectionStateChange: (BluetoothDeviceState state) {
          print('---☔️onConnectionStateChange---: $state');
          if (state == BluetoothDeviceState.disconnected) {
            info = null;
            isScanning = false;
            notifyListeners();

            _dismissDialog();
            // send check's business
            Future.delayed(Duration(seconds: 1), () => startScan());
          }

        }, onSetUserInfo: () {
          client.setUserInfo(25, 1, 170, 60, 0);
        }, onIdle: () {
          print('idle');
          isScanning = false;
          notifyListeners();

          client.toggleLive(true);
          client.enableV2ModeSpo();
        }, onHeartBeatReceived: (heartBeat) {
          print('onHeartBeatReceived: $heartBeat');
        }, onV2Live: (MegaV2Live lv) {
          print('onV2Live: $lv');
          live = lv;
          controller?.forward(from: 0.0);
          if (this.dataSpo.length >= MAX_CHART_DATA_LENGTH) {
            for (var i = 0; i < MAX_CHART_DATA_LENGTH-1; i++) {
              this.dataSpo[i].value = this.dataSpo[i+1].value;
              this.dataPr[i].value = this.dataPr[i+1].value;
            }
            this.dataSpo[MAX_CHART_DATA_LENGTH-1].value = live.spo;
            this.dataPr[MAX_CHART_DATA_LENGTH-1].value = live.pr;
          } else {
            this.dataSpo.add(LivePoint(_cnt, live.spo));
            this.dataPr.add(LivePoint(_cnt, live.pr));
            _cnt++;
          }
          print('len: ${this.dataSpo.length}; ${this.dataSpo.sublist(80)}!!');
          notifyListeners();
        }, onKnockDevice: () {
          print('onKnockDevice');
          _showKnowDialog('Ring Pairing', 'Please shake the ring', 'I know');
        }, onTokenReceived: (token) {
          print('onTokenReceived: $token');
          _dismissDialog();
        }, onOperationStatus: (cmd, status) {
          print('cmd: ${cmd.toRadixString(16)}, status: ${status.toRadixString(16)}');
          switch (status) {
            case STATUS_LOWPOWER:
              this._showKnowDialog('异常', '低电', '知道了');
              break;
            case STATUS_REFUSED:
              this._showKnowDialog('异常', '正在充电中', '知道了');
              break;
            default:
          }
        }, onBatteryChangedV2: (batt) {
          info?.batt = batt; // batt will come before info inite.
          print(batt);
          notifyListeners();
        }, onDeviceInfoReceived: (_info) {
          this.info = _info;
          this.info.name = _device.name;
          this.info.mac = _device.id.toString();
        }, onSyncingDataProgress: (progress) {
          print('progress: $progress');
        }, onSyncMonitorDataComplete: ( List<int> bytes, int dataStopType, int dataType, String uid) {
          print('synced ok. bytes len: ${bytes.length}; ${bytes.sublist(0, 40)}...');
          print('dataStopType:$dataStopType, dataType:$dataType, uid:$uid');
        }, onSyncNoDataOfMonitor: () {
          print('onSyncNoDataOfMonitor');
        }));

    client.enableDebug(true);
  }

  void _initState() {
    dataPr = genMockData();
    dataSpo = genMockData();
    notifyListeners();
  }

  void connect() async {
    _initState();

    try {
      await client.connect();
      client.startWithMasterToken();
    } catch (e) {
      print('connected error: $e');
      isScanning = false;
      Future.delayed(Duration(seconds: 1), () => startScan());
    }
  }

  void disconnect() {
    client.disconnect();
    info = null;
    live = null;
    notifyListeners();
  }

  void _showKnowDialog(String title, String content, String btnText) {
    if (isShowingDialog) {
      _dismissDialog();
    }
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(child: Text(btnText), onPressed: () {
          _dismissDialog();
        }),
      ],
    );
    isShowingDialog = true;
    showDialog(context: this._context, builder: (context) => dialog);
  }

  void _dismissDialog() {
    if (!isShowingDialog) return;
    Navigator.pop(_context);
    isShowingDialog = false;
  }

  // start scan
  void startScan() {
    if (isScanning) return;
    isScanning = true;
    notifyListeners();

    flutterBlue.startScan(timeout: Duration(seconds: 5));

    // Listen to scan results
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      results.forEach((res) {
        if (res.device.name.isEmpty ||
            !res.device.name.toLowerCase().contains('ring')) return;
        var index = _scanList.indexOf(res);
        if (index == -1) {
          _scanList.add(res);
        } else {
          _scanList[index] = res;
        }
      });
    });

    flutterBlue.isScanning.listen((isScanning) {
      print('Scanning Status: $isScanning');
    });

    Future.delayed(Duration(seconds: 8), () {
      _scanList.sort((a, b) => b.rssi.compareTo(a.rssi));
      if (_scanList.length > 0) {
        // _scanList.removeRange(9, _scanList.length);
        var target = _scanList[0];
        print('will connected: ${target.device.id}, rssi: ${target.rssi}');

        initWithDevice(target.device);
        connect();
      } else {
        Future.delayed(Duration(seconds: 2), () {
          startScan();
        });
      }
    });
  }
}
