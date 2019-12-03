import 'package:flutter_blue/flutter_blue.dart';
import 'ble_constants.dart';

class BleService {
  BluetoothService svRoot;
  BluetoothService svLog;

  BluetoothCharacteristic chWrite;
  BluetoothCharacteristic chWriteN;
  BluetoothCharacteristic chIndi;
  BluetoothCharacteristic chNoti;
  BluetoothCharacteristic chRead;

  BluetoothCharacteristic chLogCtrl;
  BluetoothCharacteristic chLogData;

  BleService(List<BluetoothService> services) {
    services.forEach((service) {
      print('${service.uuid}');
      _initService(service);
      // _initServiceEEG(service);
      service.characteristics.forEach((ch) {
        print('|---${ch.uuid}');
        _initCharacter(ch);
        // _initCharacterEEG(ch);
      });
    });
  }

  void _initService(BluetoothService service) {
    switch (service.uuid.toString()) {
      case SC_ROOT:
        svRoot = service;
        break;
      case SC_LOG_ROOT:
        svLog = service;
        break;
      default:
    }
  }
  void _initServiceEEG(BluetoothService service) {
    switch (service.uuid.toString()) {
      case SC_EEG_ROOT:
        svRoot = service;
        break;
      case SC_EEG_LOG_ROOT:
        svLog = service;
        break;
      default:
    }
  }

  void _initCharacter(BluetoothCharacteristic characteristic) {
    switch (characteristic.uuid.toString()) {
      case CH_WRITE:
        chWrite = characteristic;
        break;
      case CH_WRITE_N:
        chWriteN = characteristic;
        break;
      case CH_INDI:
        chIndi = characteristic;
        break;
      case CH_NOTI:
        chNoti = characteristic;
        break;
      case CH_READ:
        chRead = characteristic;
        break;

      case CH_LOG_CTRL:
        chLogCtrl = characteristic;
        break;
      case CH_LOG_DATA:
        chLogData = characteristic;
        break;
      default:
    }
  }

  void _initCharacterEEG(BluetoothCharacteristic characteristic) {
    switch (characteristic.uuid.toString()) {
      case CH_EEG_CTRL:
        chWrite = characteristic;
        chIndi = characteristic;
        break;
      case CH_EEG_DATA:
        chWriteN = characteristic;
        chNoti = characteristic;
        break;
      case CH_EEG_INFO:
        chRead = characteristic;
        break;

      case CH_EEG_LOG_CTRL:
        chLogCtrl = characteristic;
        break;
      case CH_EEG_LOG_DATA:
        chLogData = characteristic;
        break;
      default:
    }
  }
}
