import 'package:ble_flt/providers_send_check/ble_pvd.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

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
          title: Text('zg-p11e'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                blePvd.startScan();
                // blePvd.changeScan();
              },
            ),
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () {
                blePvd.disconnect();
                // blePvd.changeScan();

              },
            ),
          ],
        ),
      body: Consumer<BleProvider>(
      builder: (BuildContext context, BleProvider pvd, Widget child) {
        return pvd.isScanning 
            ? Center(child: CircularProgressIndicator(),) 
            : BleContent();
      //   Stack(
      //   children: <Widget>[
      //     pvd.isScanning 
      //       ? Center(child: CircularProgressIndicator(),) 
      //       : BleContent(),
      //   ],
      // );
      },
    ),
    );
  }
}

class BleContent extends StatefulWidget {
  @override
  _BleContentState createState() => _BleContentState();
}

class _BleContentState extends State<BleContent> {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(

    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        Text('Spo2(%)', style: TextStyle(color: Colors.red),),
        Consumer<BleProvider>(
          builder: (BuildContext context, BleProvider pvd, Widget child) {
            return Text(pvd.live?.spo?.toString() ?? '0', style: TextStyle(color: Colors.red, fontSize: 24));
          },
        ),
        Container(
          height: 200,
          child: Consumer<BleProvider>(
            builder: (BuildContext context, BleProvider pvd, Widget child) {
              return BleLiveLineChart(
                  pvd.dataSpo, charts.MaterialPalette.red.shadeDefault, false);
            },
          ),
        ),
        SizedBox(height: 10,),
        Text('PR(bpm)', style: TextStyle(color: Colors.blue)),
        Consumer<BleProvider>(
          builder: (BuildContext context, BleProvider pvd, Widget child) {
            return Text(pvd.live?.pr?.toString() ?? '0', style: TextStyle(color: Colors.blue, fontSize: 24));
          },
        ),
        Container(
          height: 200,
          child: Consumer<BleProvider>(
            builder: (BuildContext context, BleProvider pvd, Widget child) {
              return BleLiveLineChart(
                  pvd.dataPr, charts.MaterialPalette.blue.shadeDefault, false);
            },
          ),
        ),
      ],
    );
  }
}

// class SimpleLineChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   SimpleLineChart(this.seriesList, {this.animate});

//   /// Creates a [LineChart] with sample data and no transition.
//   factory SimpleLineChart.withSampleData() {
//     return new SimpleLineChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.LineChart(seriesList, animate: animate);
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<LivePoint, int>> _createSampleData() {
//     final data = [
//       new LivePoint(0, 5),
//       new LivePoint(1, 25),
//       new LivePoint(2, 100),
//       new LivePoint(3, 75),
//     ];

//     return [
//       new charts.Series<LivePoint, int>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (LivePoint sales, _) => sales.cnt,
//         measureFn: (LivePoint sales, _) => sales.value,
//         data: data,
//       )
//     ];
//   }
// }

class BleLiveLineChart extends StatelessWidget {
  List<LivePoint> data;
  final bool animate;
  final charts.Color color;

  BleLiveLineChart(this.data, this.color, this.animate);

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(_createData(), animate: animate);
  }

  List<charts.Series<LivePoint, int>> _createData() {
    return [
      new charts.Series<LivePoint, int>(
        id: 'Sales',
        colorFn: (_, __) => color,
        domainFn: (LivePoint sales, _) => sales.cnt,
        measureFn: (LivePoint sales, _) => sales.value,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LivePoint {
  int cnt;
  int value;

  LivePoint(this.cnt, this.value);

  @override
  String toString() {
    return '($cnt $value)';
  }
}
