import 'dart:async';

typedef ExecFn (dynamic, Exception);

class BleExecution {
  Timer _timer;
  ExecFn fn;
  BleExecution({this.fn}) {
    _timer = Timer(Duration(seconds: 5), () {
      fn(null, Exception("timeout"));
    });
  }

  get isActive => _timer.isActive;

  cancel() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }
}
