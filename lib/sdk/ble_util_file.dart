import 'dart:io';
import 'package:path_provider/path_provider.dart';

const FILE_ROOT_PATH_ANDROID = '/storage/emulated/0';

const DIR_DATA = "/megaFle/data";
const DIR_RAW_DATA = "/megaFle/rawData";
const DIR_LOG = "/megaFle/log";

class UtilFile {
  /// get root dir
  static Future<Directory> getSDRootDir() async {
    if (Platform.isAndroid) {
      return Directory(FILE_ROOT_PATH_ANDROID);
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<Directory> getDir(String path) async {
    var dir = Directory((await getSDRootDir()).path + path);
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  static Future<void> saveFile(String filename, List<int> bytes) async {
    var f = File((await getSDRootDir()).path + '/' + filename);
    if (!f.existsSync()) f.createSync(recursive: true);
    f.writeAsBytesSync(bytes);
  }

  static String getDataFileName() {
    return "ble_" + dateFormatYYMMDDHHMMSS(DateTime.now()) + ".bin";
  }

  static String getDailyDataFileName() {
    return "ble_daily_" + dateFormatYYMMDDHHMMSS(DateTime.now()) + ".bin";
  }

  static String getRawDataFileName() {
    return "raw_" + dateFormatYYMMDDHHMMSS(DateTime.now()) + ".dat";
  }

  static dateFormatYYMMDDHHMMSS(DateTime d) {
    var yy = d.year.toString().padLeft(2, '0');
    var mm = d.month.toString().padLeft(2, '0');
    var dd = d.day.toString().padLeft(2, '0');
    var hh = d.hour.toString().padLeft(2, '0');
    var mmm = d.minute.toString().padLeft(2, '0');
    var ss = d.second.toString().padLeft(2, '0');
    return '${yy}_${mm}_${dd}_${hh}_${mmm}_$ss';
  }
}
