import 'package:ble_flt/sdk/ble_beans.dart';
import 'package:ble_flt/sdk/ble_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'sdk/ble_callback.dart';

class CounterProvider with ChangeNotifier {
  int _cnt = 0;
  int get count => _cnt;

  void increment() {
    _cnt++;
    notifyListeners();
  }
}

class BoolProvider with ChangeNotifier {
  bool isConnected = false;

  void updateConnectionState(bool flag) {
    isConnected = flag;
    notifyListeners();
  }
}

class BleProvider with ChangeNotifier {
  MegaBleClient client;
  BluetoothDevice _device;
  BuildContext _context;
  MegaDeviceInfo info;
  

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
            notifyListeners();
          }

        }, onSetUserInfo: () {
          client.setUserInfo(25, 1, 170, 60, 0);
        }, onIdle: () {
          print('idle');
          notifyListeners();
        }, onHeartBeatReceived: (heartBeat) {
          print(heartBeat);
        }, onV2Live: (MegaV2Live live) {
          print(live);
        }, onKnockDevice: () {
          print('onKnockDevice');
          _showKnowDialog('Ring Pairing', 'Please shake the ring', 'I know');
        }, onTokenReceived: (token) {
          print('onTokenReceived: $token');
          _dismissDialog();
        }, onOperationStatus: (cmd, status) {
          print('cmd: ${cmd.toRadixString(16)}, status: $status');
        }, onBatteryChangedV2: (batt) {
          info.batt = batt;
          notifyListeners();
        }, onDeviceInfoReceived: (_info) {
          this.info = _info;
          this.info.name = _device.name;
          this.info.mac = _device.id.toString();
        }));

    client.enableDebug(true);
  }

  void connect() async {
    try {
      await client.connect();
      client.startWithMasterToken();
    } catch (e) {
      print(e);
    }
  }

  void disconnect() {

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
}
