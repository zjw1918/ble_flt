import 'dart:async';

import 'package:ble_flt/pages/scan_drawer.dart';
import 'package:ble_flt/pages/send_check.dart';
import 'package:flutter/material.dart';

import 'package:ble_flt/sdk/ble_beans.dart';
import 'package:ble_flt/sdk/ble_callback.dart';
import 'package:ble_flt/sdk/ble_client.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleProvider with ChangeNotifier {
  MegaBleClient client;
  BluetoothDevice _device;
  BuildContext _context;

  // notify properties
  MegaDeviceInfo info;
  MegaV2Live live;
  List<LivePoint> dataPr = [];
  List<LivePoint> dataSpo = [];

  // scan
  bool isScanning = false;
  List<ScanResult> _scanList = [];
  int _cnt = 0;

  static List<LivePoint> genMockData() {
    List<LivePoint> res = [];
    for (var i = 0; i < 100; i++) {
      res.add(LivePoint(i, 0));
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
          print(heartBeat);
        }, onV2Live: (MegaV2Live lv) {
          print('onV2Live: $lv');
          live = lv;
          if (this.dataSpo.length > 100) {
            for (var i = 0; i < 99; i++) {
              this.dataSpo[i].value = this.dataSpo[i+1].value;
            }
            this.dataSpo[99].value = live.spo;
          } else {
            this.dataSpo.add(LivePoint(_cnt++, live.spo));
          }
          // for (var i = 0; i < _cnt-1; i++) {
          //   this.dataSpo[i] = this.dataSpo[i+1];
          // }
          print('len: ${this.dataSpo.length}; ${this.dataSpo}!!');
          // this.dataSpo.add(LivePoint(_cnt++, live.spo));
          // this.dataPr.add(LivePoint(_cnt++, live.pr));
          notifyListeners();
        }, onKnockDevice: () {
          print('onKnockDevice');
          _showKnowDialog('Ring Pairing', 'Please shake the ring', 'I know');
        }, onTokenReceived: (token) {
          print('onTokenReceived: $token');
          _dismissDialog();
        }, onOperationStatus: (cmd, status) {
          print('cmd: ${cmd.toRadixString(16)}, status: $status');
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

  void connect() async {
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
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(child: Text(btnText), onPressed: () {}),
      ],
    );
    showDialog(context: this._context, builder: (context) => dialog);
  }

  void _dismissDialog() {
    Navigator.pop(_context);
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
        if (!_scanList.contains(res)) {
          _scanList.add(res);
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
        print(target.device.id);

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
