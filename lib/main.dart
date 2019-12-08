import 'package:ble_flt/pages/main_ble.dart';
import 'package:ble_flt/permissions/util_permission.dart';
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
    print('build....');
    UtilPermission.requestPermiss(() {
      print('permission ok.');
    });
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BleMainPage(),
    );
  }
}

