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
        ChangeNotifierProvider(builder: (_) => CounterProvider()),
        ChangeNotifierProvider(builder: (_) => BoolProvider()),
        ChangeNotifierProvider(builder: (_) => BleProvider()),
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
          Consumer<CounterProvider>(
            builder: (context, counterPvd, child) {
              return Text('hello world. ${counterPvd.count}');
            },
          ),
          Consumer<BoolProvider>(
            builder: (context, blePvd, child) {
              return Text(blePvd.isConnected ? "on" : "off");
            },
          )
        ],
      ),
      // Consumer<CounterProvider>(
      //   builder: (context, counterPvd, child) {
      //     return Text('hello world. ${counterPvd.count}');
      //   },
      // ),
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
      ],
    );
  }
}
