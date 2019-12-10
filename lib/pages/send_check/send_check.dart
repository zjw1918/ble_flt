import 'package:ble_flt/pages/send_check/about.dart';
import 'package:ble_flt/providers_send_check/ble_pvd.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

import 'ble_live_line_chart.dart';

class SendCheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var blePvd = Provider.of<BleProvider>(context);
    // blePvd.withContext(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BleProvider()),
      ],
      child: Pannel(),
    );
  }
}

class Pannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var blePvd = Provider.of<BleProvider>(context);
    blePvd.withContext(context);
    // blePvd.startScan();

    return Scaffold(
      appBar: AppBar(
        title: Text('ZG-' + (blePvd.info?.sn?.substring(0, 4) ?? '型号')),
        actions: <Widget>[
          Consumer<BleProvider>(
            builder: (BuildContext context, BleProvider pvd, Widget child) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: pvd.info != null ? null : pvd.isScanning ? null : () => blePvd.startScan(),
              );
            },
          ),
          Consumer<BleProvider>(
            builder: (BuildContext context, BleProvider pvd, Widget child) {
              return IconButton(
                icon: Icon(Icons.stop),
                onPressed: pvd.info == null ? null : () => blePvd.disconnect(),
              );
            },
          ),
          IconButton(
                icon: Icon(Icons.info),
                onPressed: () => Navigator.of(context).pushNamed('/about')
              ),
        ],
      ),
      body: Consumer<BleProvider>(
        builder: (BuildContext context, BleProvider pvd, Widget child) {
          return pvd.isScanning
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : blePvd.info != null
                  ? BleContent()
                  : Center(
                      child: Text('未连接'),
                    );
        },
      ),
    );
  }
}

class BleContent extends StatefulWidget {
  @override
  _BleContentState createState() => _BleContentState();
}

class _BleContentState extends State<BleContent>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    // controller.repeat();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_BleContentState built');
    var blePvd = Provider.of<BleProvider>(context);
    blePvd.controller = controller;

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            'SpO2(%)',
            style: TextStyle(color: Colors.red),
          ),
        ),
        Consumer<BleProvider>(
          builder: (BuildContext context, BleProvider pvd, Widget child) {
            return FadeTransition(
                opacity: _animation,
                child: Text(pvd.live?.spo?.toString() ?? '0',
                    style: TextStyle(color: Colors.red, fontSize: 26)));
          },
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Consumer<BleProvider>(
              builder: (BuildContext context, BleProvider pvd, Widget child) {
                return BleLiveLineChart(
                  pvd.dataSpo,
                  color: charts.MaterialPalette.red.shadeDefault,
                  animate: false,
                  tickSpecs: [
                    charts.TickSpec<num>(40),
                    charts.TickSpec<num>(70),
                    charts.TickSpec<num>(100)
                  ],
                );
              },
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 4),
            child: Text('PR(bpm)', style: TextStyle(color: Colors.blue))),
        Consumer<BleProvider>(
          builder: (BuildContext context, BleProvider pvd, Widget child) {
            return FadeTransition(
              opacity: _animation,
              child: Text(pvd.live?.pr?.toString() ?? '0',
                  style: TextStyle(color: Colors.blue, fontSize: 26)),
            );
          },
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Consumer<BleProvider>(
              builder: (BuildContext context, BleProvider pvd, Widget child) {
                return BleLiveLineChart(pvd.dataPr,
                    color: charts.MaterialPalette.blue.shadeDefault,
                    animate: false,
                    tickSpecs: [
                      charts.TickSpec<num>(30),
                      charts.TickSpec<num>(135),
                      charts.TickSpec<num>(240)
                    ]);
              },
            ),
          ),
        ),
      ],
    );
  }
}
