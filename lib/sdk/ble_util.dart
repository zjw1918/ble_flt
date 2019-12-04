import 'dart:convert';
import 'dart:math';

import 'package:ble_flt/sdk/ble_beans.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

const String CONST_62_STRING =
    'zxcvbnmlkjhgfdsaqwertyuiopQWERTYUIOPASDFGHJKLZXCVBNM1234567890';

class BleUtil {
  static Digest generateMd5(String input) {
    return md5.convert(utf8.encode(input));
  }

  static String genRandomString(int len) => List.filled(len, 0)
      .map((_) => CONST_62_STRING[Random().nextInt(CONST_62_STRING.length)])
      .join();

    static MegaDeviceInfo parseReadData(List<int> a) {
        int hw1 = (a[0] & 0xf0) >> 4;
        int hw2 = (a[0] & 0x0f);
        int fw1 = (a[1] & 0xf0) >> 4;
        int fw2 = (a[1] & 0x0f);
        int fw3 = (a[2] << 8) | a[3];
        int bl1 = (a[4] & 0xf0) >> 4;
        int bl2 = (a[4] & 0x0f);

        String sn = "0000";
        if (a[5] != 0) sn = parseSnEnter([a[5], a[6], a[7], a[8], a[9], a[10]]);

        List<int> gSENSOR4404Flag = _byteToBits(a[11]); // xyz
        int x = gSENSOR4404Flag[0];
        int y = gSENSOR4404Flag[1];
        int z = gSENSOR4404Flag[2];
        int t = gSENSOR4404Flag[3];
        String deviceCheck = "I2C[" + (x != 0 ? "y" : "n") + "] "
                + "GS[" + (y != 0 ? "y" : "n") + "] "
                + "4404[" + (z != 0 ? "y" : "n") + "] "
                + "BQ[" + (t != 0 ? "y" : "n") + "] ";
        String runFlag = a[12] == 0 ? "off" : (a[12] == 1 ? "on" : "pause");
        bool isRunning = a[12] != 0;

        String hwVer = '$hw1.$hw2';
        String fwVer = '$fw1.$fw2.$fw3';
        String blVer = '$bl1.$bl2';
        String otherInfo = 'HW: v$hwVer BL: v$blVer hwCheck: $deviceCheck run: $runFlag';

        var rawSn = [a[5], a[6], a[7], a[8], a[9], a[10]];
        var rawHwSwBl = [a[0], a[1], a[2], a[3], a[4]];

        return MegaDeviceInfo(hwVer: hwVer, fwVer: fwVer, blVer: blVer, 
          otherInfo: otherInfo, isRunning: isRunning, sn: sn,
          rawSn: rawSn, rawHwSwBl: rawHwSwBl);
    }

  /// parse sn by protocol
  static String parseSnEnter(List<int> a) {
    int verYYmm = (a[0] << 8) | a[1];
    int snVersion = (verYYmm >> 13) & 0x07;

    if (snVersion == 1) return _parseSnV1(a);
    if (snVersion == 0) return _parseSnV0(a);
    return "";
  }

  static String _parseSnV0(List<int> a) {
    String sn;
    if (RING_SN_TYPE[a[5] & 0x07] == "P11T") {
      // 没有size
      sn = RING_SN_TYPE[a[5] & 0x07];
    } else {
      // 有size
      sn = '${RING_SN_TYPE[a[5] & 0x07]}${(a[5] >> 3) & 0x0f}';
    }
    var _yy = a[0].toString().padLeft(2, '0');
    var _mm = a[1].toString().padLeft(2, '0');
    var _cnt = ((a[2] << 16) | (a[3] << 8) | a[4]).toString().padLeft(6, '0');
    return '$sn$_yy$_mm$_cnt';
  }

  static String _parseSnV1(List<int> a) {
    int verYYmm = (a[0] << 8) | a[1];

    int yy = (verYYmm >> 7) & 0x03F;
    int mm = (verYYmm >> 3) & 0x0F;
    int cnt = (a[2] << 16) | (a[3] << 8) | a[4];
    int typeIndex = (a[5] >> 5) & 0x01;
    int sizeIndex = (a[5] >> 4) & 0x01;
    int type = (a[5] & 0x0F);

    try {
      String typeName = RING_TYPE_MAP[type][typeIndex];
      int size = RING_SIZE_MAP[type][sizeIndex];
      var _yy = yy.toString().padLeft(2, '0');
      var _mm = mm.toString().padLeft(2, '0');
      var _cnt = cnt.toString().padLeft(6, '0');
      return '$typeName$size$_yy$_mm$_cnt';
    } catch (e) {
      print('_parseSnV1 error: $e');
    }
    return "";
  }

  static List<int> _byteToBits(int b) {
      var bits = List.filled(8, 0);
      for (int i = 7; i >= 0; i--) {
          bits[i] = ((b & (1 << i)) == 0 ? 0 : 1);
      }
      return bits;
  }
}

/// parse sn utils
const Map<int, String> RING_SN_TYPE = {
  0: "P11A",
  1: "P11B",
  2: "P11C",
  3: "P11D",
  7: "P11T",
  4: "E11D",
};

const Map<int, List<String>> RING_TYPE_MAP = {
  5: ["C11E", "P11E"],
};

const Map<int, List<int>> RING_SIZE_MAP = {
  5: [2, 3],
};
