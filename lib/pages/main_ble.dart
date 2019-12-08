import 'package:ble_flt/permissions/util_permission.dart';
import 'package:ble_flt/sdk/ble_util_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pvd.dart';
import 'scan_drawer.dart';

class BleMainPage extends StatefulWidget {
  @override
  _BleMainPageState createState() => _BleMainPageState();
}

class _BleMainPageState extends State<BleMainPage> {
  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<CounterProvider>(context);
    var boolProvider = Provider.of<BoolProvider>(context);
    var bleProvider = Provider.of<BleProvider>(context)..withContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ble sdk flt'),
        actions: <Widget>[
          _buildCmdMenu(bleProvider),
        ],
      ),
      drawer: ScanDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: _buildBtns(bleProvider),
          ),
          Container(
            height: 40,
            child: _buildBtns2(),
          ),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildCmdMenu(BleProvider bleProvider) {
    List<CmdHandler> list = [
      CmdHandler('收数据', () => bleProvider.client.syncData()),
      CmdHandler('reset', () => bleProvider.client.reset()),
      CmdHandler('shutdown', () => bleProvider.client.shutdown()),
    ];
    return PopupMenuButton<CmdHandler>(
      onSelected: (CmdHandler result) => result.fn(),
      itemBuilder: (BuildContext context) => list.map((i) => PopupMenuItem<CmdHandler>(
        value: i,
        child: Text(i.name),
      )).toList()
    );
  }

  Widget _buildBtns(BleProvider bleProvider) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        RaisedButton(
          child: Text('连接'),
          onPressed: () {
            bleProvider.connect();
          },
        ),
        RaisedButton(
          child: Text('断开'),
          onPressed: () {
            bleProvider.client.disconnect();
          },
        ),
        RaisedButton(
          child: Text('开live'),
          onPressed: () {
            bleProvider.client.toggleLive(true);
          },
        ),
        RaisedButton(
          child: Text('开血氧'),
          onPressed: () {
            bleProvider.client.enableV2ModeSpo();
          },
        ),
        RaisedButton(
          child: Text('开运动'),
          onPressed: () {
            bleProvider.client.enableV2ModeSport();
          },
        ),
        RaisedButton(
          child: Text('关监测'),
          onPressed: () {
            bleProvider.client.enableV2ModeDaily();
          },
        ),
      ],
    );
  }

  Widget _buildBtns2() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        RaisedButton(
          child: Text('写文件'),
          onPressed: () {
            UtilPermission.requestPermiss(() async {
              UtilFile.saveFile('megaFlt/data/' + UtilFile.getDailyDataFileName(), [0,1,2,3,4,5,6,7,8,9]);
              // var dir = await UtilBle.getSDRootDir();
              // var lessonDir = Directory(dir.path + '/BleFlt/');
              // if (!lessonDir.existsSync()) {
              //   lessonDir.createSync(recursive: true);
              // }

              // // var dir2 = await getApplicationDocumentsDirectory();
              // // print(dir2.path);

              // var f1 = File(lessonDir.path + '/a.txt');
              // f1.writeAsBytes(utf8.encode('hello'), mode: FileMode.append);
            });
          },
        ),
        RaisedButton(
          child: Text('读文件'),
          onPressed: () async {
            // var f1 = File(FILE_ROOT_PATH_ANDROID + '/BleFlt/a.txt');
            // if (f1.existsSync()) {
            //   print(f1.readAsStringSync());
            // }
          },
        ),
        RaisedButton(
          child: Text('删文件夹'),
          onPressed: () async {
            // var d = Directory(FILE_ROOT_PATH_ANDROID + '/BleFlt');
            // if (d.existsSync()) {
            //   d.delete(recursive: true);
            // }
          },
        ),
        RaisedButton(
          child: Text('菜单'),
          onPressed: () {
            
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Consumer<BleProvider>(
      builder: (BuildContext context, blePvd, Widget child) {
        return DefaultTextStyle(
          style: TextStyle(fontSize: 16, color: Colors.black54),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('Name:')),
                  Expanded(flex: 4, child: Text(blePvd?.info?.name ?? '-')),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('Mac:')),
                  Expanded(flex: 4, child: Text(blePvd?.info?.mac ?? '-')),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('SN:')),
                  Expanded(flex: 4, child: Text(blePvd?.info?.sn ?? '-')),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(flex: 1, child: Text('Version:')),
                  Expanded(flex: 4, child: Text(blePvd?.info?.fwVer ?? '-')),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Text('Other:')),
                  Expanded(
                      flex: 4, child: Text(blePvd?.info?.otherInfo ?? '-')),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Text('🔋:')),
                  Expanded(
                      flex: 4,
                      child: Text('${blePvd?.info?.batt?.toString() ?? '-'}')),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 1, child: Text('Live:')),
                  Expanded(
                      flex: 4, child: Text(blePvd?.live?.toString() ?? '-')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class CmdHandler {
  const CmdHandler(this.name, this.fn);
  final String name;
  final Function fn;
}