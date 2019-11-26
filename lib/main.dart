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
    
    return Scaffold(
      appBar: AppBar(
        title: Text('ble sdk flt'),
      ),
      drawer: ScanDrawer(),
      body: Column(children: <Widget>[
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
      ],),
      // Consumer<CounterProvider>(
      //   builder: (context, counterPvd, child) {
      //     return Text('hello world. ${counterPvd.count}');
      //   },
      // ),
      floatingActionButton: Row(children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            counterProvider.increment();
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.bluetooth),
          onPressed: () {
            boolProvider.updateConnectionState(!boolProvider.isConnected);
          },
        ),
      ],),
    );
  }
}
