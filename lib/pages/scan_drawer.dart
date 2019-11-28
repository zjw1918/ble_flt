import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


FlutterBlue flutterBlue = FlutterBlue.instance;

/// drawer is better a listview

class ScanDrawer extends StatefulWidget {
  @override
  _ScanDrawerState createState() => _ScanDrawerState();
}

class _ScanDrawerState extends State<ScanDrawer> {
  List<ScanResult> scanList = [];
  Timer timer;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    print("open");
  }

  @override
  void dispose() {
    print("close");

    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    flutterBlue.stopScan();
    _isScanning = false;

    super.dispose();
  }

  _scan() {
    setState(() {
      _isScanning = true;
      scanList.clear();
    });

    flutterBlue.startScan(timeout: Duration(seconds: 10));

    // Listen to scan results
    flutterBlue.scanResults.listen((List<ScanResult> _list) {
      // do something with scan result
      print('length: ${_list.length}');
      _list.asMap().forEach((i, res) {
        if (res.device.name.isEmpty ||
            !res.device.name.toLowerCase().contains('ring')) return;
        // print("$i scaned: ${res.device.name}, rssi: ${res.rssi}");
        int index = scanList.indexOf(res);
        if (index == -1) {
          scanList.add(res);
        } else {
          scanList.removeAt(index);
          scanList.insert(index, res);
        }
      });
    });

    flutterBlue.isScanning.listen((isScanning) {
      print('Scanning Status: $isScanning');
    });
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        scanList.sort((a, b) => b.rssi.compareTo(a.rssi));
        if (scanList.length > 5) {
          scanList.removeRange(6, scanList.length);
        }
      });
      print(t.tick);
      if (t.tick == 10) {
        t.cancel();
        _updateScanningView(false);
      }
    });
  }

  _updateScanningView(bool isScanning) {
    setState(() {
      _isScanning = isScanning;
    });
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 1,
      ),
      padding: EdgeInsets.zero,
      itemCount: scanList.length,
      itemBuilder: (context, index) {
        final item = scanList[index];
        return ListTile(
          onTap: () {
            print(123123);
          },
          title: Text(item.device.name),
          subtitle: Text(item.device.id.toString()),
          trailing: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.rss_feed),
                    Text(item.rssi.toString()),
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        );
        // Container(
        //   decoration: BoxDecoration(
        //       border: Border(
        //           bottom:
        //               BorderSide(width: 1, color: Colors.grey.shade300))),
        //   height: 60,
        //   alignment: Alignment.center,
        //   child: Text('${device.name}  ${device.id}  ${item.rssi}'),
        // ),
        // ),
        // );
        // return Text('${device.name} - ${device.id} - ${rssi}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: Colors.blue,
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            alignment: Alignment.center,
            child: Text(
              '扫描',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            child: _buildListView(),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Colors.grey.shade300,
              onPressed: _isScanning ? null : _scan,
              child: Text(_isScanning ? '扫描中...' : '开始扫描'),
            ),
          ),
        ],
      ),
    );
  }
}
