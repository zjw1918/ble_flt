import 'package:ble_flt/sdk/ble_service.dart';

class MegaCmdApiManager {
  final BleService service;

  const MegaCmdApiManager({this.service});

  initPipes() async {
    await this.service.chIndi.setNotifyValue(true);
    await this.service.chNoti.setNotifyValue(true);

    this.service.chIndi.value.listen((value) {
      print(value);
    });

    this.service.chNoti.value.listen((value) {
      print(value);
    });
  }

  void sendHeartBeat() {

  }

  void readRssi() {
    
  }
}
