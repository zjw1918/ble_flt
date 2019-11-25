import 'package:flutter_blue/flutter_blue.dart';

class MegaBleClient {
  final BluetoothDevice device;
  

  const MegaBleClient(this.device);

  connect() async {
    try {
      await device.connect(autoConnect: false, timeout: Duration(seconds: 5));
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) {
        print('${service.uuid}');
        service.characteristics.forEach((ch) {
          print('|---${ch.uuid}');
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
