import 'package:ble_flt/pages/scan_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pvd.dart';

// void main() => runApp(ChangeNotifierProvider(
//   child: MyApp(),
//   builder: (context) => CounterProvider()),
// );

void main() => runApp(MultiProvider(
      providers: [
        // Provider<CounterProvider>.value(value: CounterProvider(),),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => BoolProvider()),
        ChangeNotifierProvider(create: (_) => BleProvider()),
      ],
      child: MyApp(),
      // builder: (context) => CounterProvider()),
    ));

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
  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<CounterProvider>(context);
    var boolProvider = Provider.of<BoolProvider>(context);
    var bleProvider = Provider.of<BleProvider>(context)..withContext(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ble sdk flt'),
      ),
      drawer: ScanDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: _buildBtns(bleProvider),
          ),
          _buildContent(),
        ],
      ),
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
          child: Text('xxx'),
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
                  Expanded(flex: 4, child: Text('${blePvd?.info?.batt?.toString() ?? '-' }')),

              ],)
            ],
          ),
        );
      },
    );
  }
}
