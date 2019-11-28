// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:ble_flt/sdk/ble_cmd_maker.dart';
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
    var r = BleUtil.genRandomString(12);
    print(r);
    print(utf8.encode(r));
    print(utf8.decode(utf8.encode(r)));
    // print(generateMd5Bytes('hello'));
    print(hex.encode([0, 0, 0, 93, 223, 160, 175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));

    print(hex.encode(CmdMaker.makeV2EnableModeSpoMonitor(true, DateTime.now().millisecondsSinceEpoch ~/ 1000)));
  });
}
