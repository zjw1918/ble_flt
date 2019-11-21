import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(MyApp());

FlutterBlue flutterBlue = FlutterBlue.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ScanResult> scanList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ble sdk Flt'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      print(123);
                      flutterBlue.startScan();

                      // Listen to scan results
                      flutterBlue.scanResults.listen((List<ScanResult> _list) {
                        // do something with scan result
                        print('length: ${_list.length}');
                        _list.asMap().forEach((i, res) {
                          // if (res.device.name.isEmpty ||
                          //     !res.device.name.toLowerCase().contains('ring'))
                          //   return;
                          print(
                              "$i scaned -> ${res.device.name}, rssi: ${res.rssi}");
                          setState(() {
                            if (scanList.contains(res)) {
                              // var i = scanList.indexOf(res);
                              // scanList.removeAt(i);
                              // scanList.insert(i, res);
                              scanList.remove(res);
                              // scanList.add(res);
                            }
                            scanList.add(res);
                          });
                        });
                      });

                      flutterBlue.isScanning.listen((isScanning) {
                        print('Scanning Status: $isScanning');
                      });
                    },
                    child: Text('scan'),
                  ),
                  SizedBox(width: 4),
                  RaisedButton(
                    onPressed: () {
                      flutterBlue.stopScan();
                    },
                    child: Text('stop'),
                  ),
                ],
              ),
            ),

            // list view
            Container(
              height: 400,
              color: Colors.grey.shade100,
              child: ListView.builder(
                itemCount: scanList.length,
                itemBuilder: (context, index) {
                  final item = scanList[index];
                  final device = item.device;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        try {
                          await device.connect(
                              autoConnect: false,
                              timeout: Duration(seconds: 5));
                          List<BluetoothService> services =
                              await device.discoverServices();
                          services.forEach((service) {
                            print('${service.uuid}');
                            service.characteristics.forEach((ch) {
                              print('|---${ch.uuid}');
                            });
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.grey.shade300))),
                        height: 60,
                        alignment: Alignment.center,
                        child:
                            Text('${device.name}  ${device.id}  ${item.rssi}'),
                      ),
                    ),
                  );
                  // return Text('${device.name} - ${device.id} - ${rssi}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
