import 'package:ble_flt/sdk/ble_client.dart';
import 'package:flutter/material.dart';

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

  BleProvider({this.client});
  
}