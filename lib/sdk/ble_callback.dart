import 'package:flutter_blue/flutter_blue.dart';

// typedef a = void Function(BluetoothDeviceState state);

class MegaCallback {
  MegaCallback({
    this.onConnectionStateChange,
    this.onTokenReceived,
    this.onKnockDevice,
    this.onOperationStatus,
    this.onEnsureBindWhenTokenNotMatch,
    this.onError,
  });

  final void Function(BluetoothDeviceState state) onConnectionStateChange;
  final void Function(String token) onTokenReceived;
  final void Function() onKnockDevice;
  final void Function(int cmd, int status) onOperationStatus;
  final void Function() onEnsureBindWhenTokenNotMatch;
  final void Function(int errorCode) onError;
}
