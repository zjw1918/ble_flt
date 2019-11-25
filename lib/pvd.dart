import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  int _cnt = 0;
  int get count => _cnt;
  
  void increment() {
    _cnt++;
    notifyListeners();
  }
}

class BleProvider with ChangeNotifier {
  bool isConnected;

  void updateConnectionState(bool flag) {
    isConnected = flag;
  }

}