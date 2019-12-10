import 'package:ble_flt/pages/main_ble.dart';
import 'package:ble_flt/pages/send_check/about.dart';
import 'package:ble_flt/permissions/util_permission.dart';
import 'package:ble_flt/providers_send_check/ble_pvd.dart' as sendCheckPvd;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/send_check/send_check.dart';
import 'pvd.dart' as basePvd;

// void main() => runApp(ChangeNotifierProvider(
//   child: MyApp(),
//   builder: (context) => CounterProvider()),
// );


// void main() => runApp(MultiProvider(
//   providers: [
//     // Provider<CounterProvider>.value(value: CounterProvider(),),
//     ChangeNotifierProvider(create: (_) => basePvd.CounterProvider()),
//     ChangeNotifierProvider(create: (_) => basePvd.BoolProvider()),
//     ChangeNotifierProvider(create: (_) => basePvd.BleProvider()),
//   ],
//   child: MyApp(),
//   // builder: (context) => CounterProvider()),
// ));

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
      routes: {
        // '/': (_) => SendCheckPage(),
        '/about': (_) => AboutPage(),
      },
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


class SendCheckApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sendCheckPvd.BleProvider()),
      ],
      child:  MaterialApp(
        title: 'Send Check App',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SendCheckPage(),
        routes: {
          // '/': (_) => SendCheckPage(),
          '/about': (_) => AboutPage(),
        },
      ),
    );
  }
}

void main() => runApp(SendCheckApp());