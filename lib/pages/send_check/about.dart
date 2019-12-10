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

    print([
      appName,
      packageName,
      version,
      buildNumber,
    ]);
    setState(() {
      _version = '$version-build.$buildNumber';
    });
  }

  @override
  Widget build(BuildContext context) {
    var blePvd = Provider.of<BleProvider>(context);
    print(blePvd);

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('hahaha'),
          onTap: () {},
        ),
        ListTile(
          title: Text('hahaha'),
          onTap: () {},
        ),
        ListTile(
          title: Text('版本: $_version'),
          onTap: () {},
        ),
      ],
    );
  }
}
