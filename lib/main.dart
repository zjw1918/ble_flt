import 'package:ble_flt/pages/main_ble.dart';
import 'package:ble_flt/pages/send_check.dart';
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
    
    // send check, 送检app
   return MaterialApp(
      title: 'Mega Ble',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SendCheckPage(),
    );

    // return MaterialApp(
    //   title: 'Mega Ble',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: SendCheckPage(),
    //   // home: BleMainPage(),
    // );
  }
}

