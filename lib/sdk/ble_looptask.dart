import 'dart:async';

const int PERIOD_HEART_BEAT = 15; // 默认是15s发送一次
const int PERIOD_READ_RSSI = 9;

class LoopTaskManager {
  List<Timer> timers;
  final Function onSendHeartBeat;
  final Function onReadRssi;
  
  LoopTaskManager({this.onSendHeartBeat, this.onReadRssi}) {
    timers.addAll([
      Timer.periodic(Duration(seconds: PERIOD_HEART_BEAT), (t) => this.onSendHeartBeat()),
      Timer.periodic(Duration(seconds: PERIOD_READ_RSSI), (t) => this.onReadRssi()),
    ]);
  }

  void clearLoops() {
    if (timers.isNotEmpty) {
      timers.forEach((t) => t.cancel());
      timers.clear();
    }
  }

}
