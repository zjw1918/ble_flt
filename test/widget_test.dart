// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:ble_flt/sdk/ble_cmd_maker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:ble_flt/main.dart';
import 'package:ble_flt/sdk/ble_util.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  test("md5", () {
    // var r = UtilBle.genRandomString(12);
    // print(r);
    // print(utf8.encode(r));
    // print(utf8.decode(utf8.encode(r)));
    // // print(generateMd5Bytes('hello'));
    // print(hex.encode([0, 0, 0, 93, 223, 160, 175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));

    // print(hex.encode(CmdMaker.makeV2EnableModeSpo(true, DateTime.now().millisecondsSinceEpoch ~/ 1000)));

    // List<int> a = List.filled(10, 0);
    // print(a + [99]);

    var d = DateTime.now();
    var yy = d.year.toString().padLeft(2, '0');
    var mm = d.month.toString().padLeft(2, '0');
    var dd = d.day.toString().padLeft(2, '0');
    var hh = d.hour.toString().padLeft(2, '0');
    var mmm = d.minute.toString().padLeft(2, '0');
    var ss = d.second.toString().padLeft(2, '0');
    print('${yy}_${mm}_${dd}_${hh}_${mmm}_$ss');
  });
}
