import 'package:permission_handler/permission_handler.dart';

class UtilPermission {
  static requestPermiss(callback) async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
      callback();
    } else {
      print("无存储权限");
    }
    // //校验权限
    // if(permissions[PermissionGroup.camera] != PermissionStatus.camera){
    //   print("无照相权限");
    // }
    // if(permissions[PermissionGroup.location] != PermissionStatus.location){
    //   print("无定位权限");
    // }
  }

  static getStoragePermission() {
    var permission =
        PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    PermissionHandler().requestPermissions(<PermissionGroup>[
      // storage权限
      PermissionGroup.storage,
      // 照相权限
      PermissionGroup.camera,
      // 定位权限
      PermissionGroup.location,
    ]);
  }
}
