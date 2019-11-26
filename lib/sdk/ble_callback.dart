import 'package:flutter_blue/flutter_blue.dart';

abstract class IMegaCallback {
  void onConnectionStateChange(BluetoothDeviceState state);
}
