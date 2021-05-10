import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/utils.dart';

import 'detailed_stats_all.dart';

class DetailedStats extends StatefulWidget {
  final StatType statType;
  final int maxDataPoints;
  final double recentSecondsLimit;

  DetailedStats(this.statType,
      {this.maxDataPoints = 25, this.recentSecondsLimit = 43200});

  @override
  _DetailedStatsState createState() => _DetailedStatsState();
}

class _DetailedStatsState extends State<DetailedStats> {
  List<TimeSeriesStat> dataPoints = [];
  List<charts.Series<TimeSeriesStat, DateTime>> _seriesList;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/$uid/sensor_data/${widget.statType.fieldName}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.statType.label}: 12 hour log",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder<Event>(
          stream: ref
              .orderByChild("timestamp")
              .startAt(DateTime.now().millisecondsSinceEpoch.toDouble() / 1000 -
                  widget.recentSecondsLimit)
              .limitToLast(widget.maxDataPoints)
              .onValue,
          builder: (context, event) {
            if (event.hasError) {
              return Center(child: Text("Something went wrong!"));
            }
            if (!(event.connectionState == ConnectionState.waiting)) {
              // Programmed so that every snapshot, the data points are
              // completely replaced, and the series is completely rebuilt.
              // Currently this is the only way I found to forcibly update the
              // graph state.
              if (event.hasData && event.data.snapshot.value != null) {
                dataPoints = [];
                Map<String, dynamic> data =
                    Map<String, dynamic>.from(event.data.snapshot.value);
                data.forEach((key, value) {
                  if (value[widget.statType.fieldName] != null) {
                    // assumed to be numeric
                    // todo what if it string or categorical?
                    dynamic stat = value[widget.statType.fieldName];
                    if (stat is int) {
                      stat = (stat as int).toDouble();
                    }
                    dataPoints.add(TimeSeriesStat(
                        Utils.dateTimeFromSeconds(value["timestamp"]), stat));
                  }
                });
                dataPoints.sort((a, b) => b.time.compareTo(a.time));
              }
            }
            _constructSeries();
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: height * 0.4,
                  child: charts.TimeSeriesChart(
                    _seriesList,
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                  ),
                ),
                Text(widget.statType.label),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        DataTable(
                          columns: [
                            DataColumn(
                              label: Text("Time"),
                            ),
                            DataColumn(
                              label: Text(widget.statType.label),
                            ),
                          ],
                          rows: dataPoints
                              .map(
                                (d) => DataRow(
                                  cells: [
                                    DataCell(Text(d.time.toString())),
                                    DataCell(Text(d.stat.toString())),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        dataPoints.isEmpty
                            ? Text("No data recorded in the last 12 hours")
                            : Container(),
                        ElevatedButton(
                          child: Text("View all past data"),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailedStatsAll(widget.statType),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _constructSeries() {
    _seriesList = [
      charts.Series<TimeSeriesStat, DateTime>(
        id: 'Stats',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesStat stats, _) => stats.time,
        measureFn: (TimeSeriesStat stats, _) => stats.stat,
        data: dataPoints,
      ),
    ];
  }
}
