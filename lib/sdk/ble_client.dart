import 'package:ble_flt/sdk/ble_callback.dart';
import 'package:ble_flt/sdk/ble_cmd_api.dart';
import 'package:ble_flt/sdk/ble_response.dart';
import 'package:ble_flt/sdk/ble_service.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MegaBleClient {
  final BluetoothDevice device;
  final MegaCallback callback;
  BleService _service;
  MegaCmdApiManager _apiManager;
  MegaBleResponseManager _responseManager;


  MegaBleClient({this.device, this.callback});

  connect() async {
    await device.connect(autoConnect: false, timeout: Duration(seconds: 5));
    List<BluetoothService> services = await device.discoverServices();
    _service = BleService(services);
    _apiManager = MegaCmdApiManager(service: _service);
    await _init();
  }

  _init() async {
    _responseManager = MegaBleResponseManager(_apiManager, callback);
    await _apiManager.initPipes();
    _service.chIndi.value.listen((value) {
      _responseManager.handleIndicateResponse(value);
    });
    _service.chNoti.value.listen((value) {
      _responseManager.handleNotifyResponse(value);
    });
    device.state.listen((value) {
      callback.onConnectionStateChange(value);
    });
  }

  disconnect() async {
    await device.disconnect();
  }

  Future<int> startWithMasterToken() {
    return Future.value(1);
  }

}
