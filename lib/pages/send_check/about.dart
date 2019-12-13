import 'package:ble_flt/providers_send_check/ble_pvd.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  void _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    // print([
    //   appName,
    //   packageName,
    //   version,
    //   buildNumber,
    // ]);
    setState(() {
      _version = '$version-build.$buildNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    var blePvd = Provider.of<BleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                blePvd.info == null 
                ? ListTile(leading: Icon(Icons.bluetooth, size: 50), title: Text('未连接'),)
                : ListTile(
                  leading: Icon(Icons.bluetooth, size: 50),
                  title: Text('Name: ${blePvd.info?.name ?? '-'} Mac: ${blePvd.info?.mac ?? '-'}'),
                  subtitle: Text('SN: ${blePvd.info?.sn ?? '-'} FW: ${blePvd.info?.fwVer ?? '-'}'),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('版本: $_version'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
