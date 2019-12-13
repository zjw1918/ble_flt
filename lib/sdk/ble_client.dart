import 'dart:async';

import 'package:ble_flt/sdk/ble_callback.dart';
import 'package:ble_flt/sdk/ble_cmd_api.dart';
import 'package:ble_flt/sdk/ble_response.dart';
import 'package:ble_flt/sdk/ble_service.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'ble_beans.dart';

class MegaBleClient {
  final BluetoothDevice device;
  final MegaCallback callback;
  BleService _service;
  MegaCmdApiManager _apiManager;
  MegaBleResponseManager _responseManager;
  List<StreamSubscription> listeners = [];

  MegaBleClient({this.device, this.callback});

  connect() async {
    await device.connect(autoConnect: false);
    List<BluetoothService> services = await device.discoverServices();
    _service = BleService(services);
    _apiManager = MegaCmdApiManager(service: _service);
    await _init();
  }

  _init() async {
    _responseManager = MegaBleResponseManager(_apiManager, callback);
    await _apiManager.initPipes();
    var a = _service.chIndi.value.listen((value) {
      _responseManager.handleIndicateResponse(value);
    });

    var b = _service.chNoti.value.listen((value) {
      _responseManager.handleNotifyResponse(value);
    });
    var c = device.state.listen((value) {
      if (value == BluetoothDeviceState.disconnected) {
        _responseManager.handleDisConnect();
        listeners.forEach((sub) {
          sub.cancel();
        });
      }
      callback.onConnectionStateChange(value);
    });
    listeners.addAll([a, b, c]);
  }

  disconnect() async {
    listeners.forEach((sub) => sub.cancel());
    _responseManager.handleDisConnect();
    await device.disconnect();
  }

  startWithMasterToken() {
    _apiManager.bindWithMasterToken();
  }

  enableDebug(bool flag) {
    BleConfig.debuggable = flag;
  }

  setUserInfo(int age, int gender, int height, int weight, int stepLength) {
    _apiManager.setUserInfo(age, gender, height, weight, stepLength);
  }

  void toggleLive(bool enable) {
    _apiManager.toggleLive(enable);
  }

  /// enable spo2
  void enableV2ModeSpo() {
    _apiManager.enableV2ModeSpo(true, 0);
  }
  /// enable sport
  void enableV2ModeSport() {
    _apiManager.enableV2ModeSport(true, 0);
  }
  /// enable daily / stop monitor
  void enableV2ModeDaily() {
    _apiManager.enableV2ModeDaily(true, 0);
  }

  void enableV2ModeLive() {
    _apiManager.enableV2ModeLiveSpo(true, 0);
  }

  void syncData() => _apiManager.syncMonitorData();
  void syncDailyData() => _apiManager.syncDailyData();
  void reset() => _apiManager.reset();
  void shutdown() => _apiManager.shutdown();

}
