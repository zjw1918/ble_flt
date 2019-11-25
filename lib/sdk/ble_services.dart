import 'package:flutter_blue/flutter_blue.dart';
import 'inner_constants.dart';

class BleService {
  BluetoothService svRoot;
  BluetoothService svLog;

  BluetoothCharacteristic chWrite;
  BluetoothCharacteristic chWriteN;
  BluetoothCharacteristic chIndi;
  BluetoothCharacteristic chNoti;
  BluetoothCharacteristic chRead;

  BluetoothCharacteristic chLogWrite;
  BluetoothCharacteristic chLogNotiWriteN;

  BleService(List<BluetoothService> services) {
    services.forEach((service) {
      _initService(service);
      print('${service.uuid}');
      service.characteristics.forEach((ch) {
        _initCharacter(ch);
        print('|---${ch.uuid}');
      });
    });
  }

  void _initService(BluetoothService service) {
    switch (service.uuid.toString()) {
      case SC_FAB1:
        svRoot = service;
        break;
      case SC_FAF1:
        svLog = service;
        break;
      default:
    }
  }

  void _initCharacter(BluetoothCharacteristic characteristic) {
    switch (characteristic.uuid.toString()) {
      case CH_FAB2:
        chWrite = characteristic;
        break;
      case CH_FAB3:
        chWriteN = characteristic;
        break;
      case CH_FAB4:
        chIndi = characteristic;
        break;
      case CH_FAB5:
        chNoti = characteristic;
        break;
      case CH_FAB6:
        chRead = characteristic;
        break;

      case CH_FAF2:
        chLogWrite = characteristic;
        break;
      case CH_FAF3:
        chLogNotiWriteN = characteristic;
        break;
      default:
    }
  }
}
