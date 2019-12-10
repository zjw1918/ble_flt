import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LivePoint {
  int cnt;
  int value;

  LivePoint(this.cnt, this.value);

  @override
  String toString() {
    return '($cnt $value)';
  }
}

class BleLiveLineChart extends StatelessWidget {
  List<LivePoint> data;
  final bool animate;
  final charts.Color color;
  List<charts.TickSpec<num>> tickSpecs;

  BleLiveLineChart(this.data, {this.color, this.animate, this.tickSpecs});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      _createData(),
      animate: animate,
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(this.tickSpecs),
      ),
      domainAxis: charts.NumericAxisSpec(
          showAxisLine: true, renderSpec: charts.NoneRenderSpec()),
    );
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
