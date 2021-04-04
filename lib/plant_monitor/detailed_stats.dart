import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class DetailedStats extends StatefulWidget {
  @override
  _DetailedStatsState createState() => _DetailedStatsState();
}

class _DetailedStatsState extends State<DetailedStats> {
  List<TimeSeriesStat> data = [
    TimeSeriesStat(DateTime(2017, 9, 19), 5),
    TimeSeriesStat(DateTime(2017, 9, 26), 25),
    TimeSeriesStat(DateTime(2017, 10, 3), 100),
    TimeSeriesStat(DateTime(2017, 10, 10), 75),
  ];
  List<charts.Series<TimeSeriesStat, DateTime>> _seriesList;
  DateTime _currTime = DateTime(2017, 10, 11);

  Random _rng = Random();
  Timer _valueTimer;

  @override
  void initState() {
    super.initState();

    _seriesList = <charts.Series<TimeSeriesStat, DateTime>>[
      charts.Series<TimeSeriesStat, DateTime>(
        id: 'Stats',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesStat stats, _) => stats.time,
        measureFn: (TimeSeriesStat stats, _) => stats.stat,
        data: data,
      ),
    ];

    _valueTimer = Timer.periodic(
      Duration(seconds: 2),
      (timer) {
        setState(() {
          var x = _rng.nextInt(80).toDouble();
          data.add(TimeSeriesStat(_currTime, x));
          _currTime = _currTime.add(Duration(hours: 13));
          _seriesList = <charts.Series<TimeSeriesStat, DateTime>>[
            charts.Series<TimeSeriesStat, DateTime>(
              id: 'Stats',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (TimeSeriesStat stats, _) => stats.time,
              measureFn: (TimeSeriesStat stats, _) => stats.stat,
              data: data,
            ),
          ];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: height * 0.4,
            child: charts.TimeSeriesChart(
              _seriesList,
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
          ),
          Text("hello"),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Time"),
                  ),
                  DataColumn(
                    label: Text("Data type"),
                  ),
                ],
                rows: [
                  ...data.reversed.map((d) => DataRow(
                        cells: [
                          DataCell(Text(d.time.toString())),
                          DataCell(Text(d.stat.toString())),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _valueTimer.cancel();
  }
}

/// Sample time series data type.
class TimeSeriesStat {
  final DateTime time;
  final double stat;

  TimeSeriesStat(this.time, this.stat);
}
