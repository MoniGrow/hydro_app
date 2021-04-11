import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:hydro_app/utils.dart';

class DetailedStats extends StatefulWidget {
  final String fieldName;
  final int maxDataPoints;
  // TODO: also limit data by how recent the data is

  DetailedStats(this.fieldName, {this.maxDataPoints = 50});

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
    CollectionReference data = FirebaseFirestore.instance
        .collection(FirebaseConst.USER_COLLECTION)
        .doc(uid)
        .collection(FirebaseConst.SENSOR_DATA_COLLECTION);

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: data
              .orderBy("timestamp", descending: true)
              .limit(widget.maxDataPoints)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            }
            if (!(snapshot.connectionState == ConnectionState.waiting)) {
              // Programmed so that every snapshot, the data points are
              // completely replaced, and the series is completely rebuilt.
              // Currently this is the only way I found to forcibly update the
              // graph state.
              if (snapshot.data.docs.isNotEmpty) {
                dataPoints = snapshot.data.docs.map((e) {
                  return TimeSeriesStat(
                      (e.data()["timestamp"] as Timestamp).toDate(),
                      (e.data()[widget.fieldName] as int).toDouble());
                }).toList();
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
                        ...dataPoints.map((d) => DataRow(
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

/// Sample time series data type.
class TimeSeriesStat {
  final DateTime time;
  final double stat;

  TimeSeriesStat(this.time, this.stat);
}
