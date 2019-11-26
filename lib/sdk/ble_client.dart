import 'package:ble_flt/sdk/ble_callback.dart';
import 'package:ble_flt/sdk/ble_response.dart';
import 'package:ble_flt/sdk/ble_service.dart';
import 'package:flutter_blue/flutter_blue.dart';

class MegaBleClient {
  final BluetoothDevice device;
  final IMegaCallback callback;
  BleService _bleSvc;
  MegaBleResponseManager _responseManager;


  MegaBleClient({this.device, this.callback});

  connect() async {
    await device.connect(autoConnect: false, timeout: Duration(seconds: 5));
    List<BluetoothService> services = await device.discoverServices();
    _bleSvc = BleService(services);
    await _init();
  }

  _init() async {
    _responseManager = MegaBleResponseManager(service: _bleSvc);
    await _bleSvc.initPipes();
    _bleSvc.chIndi.value.listen((value) {
      _responseManager.handleIndicateResponse(value);
    });
    _bleSvc.chNoti.value.listen((value) {
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
