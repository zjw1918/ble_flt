import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

const String CONST_62_STRING =
    'zxcvbnmlkjhgfdsaqwertyuiopQWERTYUIOPASDFGHJKLZXCVBNM1234567890';

class BleUtil {
  static Digest generateMd5(String input) {
    return md5.convert(utf8.encode(input));
  }

  static String genRandomString(int len) => List.filled(len, 0)
      .map((_) => CONST_62_STRING[Random().nextInt(CONST_62_STRING.length)])
      .join();
}
