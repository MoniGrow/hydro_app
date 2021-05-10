import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/utils.dart';

/// Screen to display the table of even more stats
class DetailedStatsAll extends StatefulWidget {
  final StatType statType;
  final int maxDataPoints; // todo should probably update as scroll down idk

  DetailedStatsAll(this.statType, {this.maxDataPoints = 100});

  @override
  _DetailedStatsAllState createState() => _DetailedStatsAllState();
}

class _DetailedStatsAllState extends State<DetailedStatsAll> {
  List<TimeSeriesStat> dataPoints = [];

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/$uid/sensor_data/${widget.statType.fieldName}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.statType.label,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: StreamBuilder<Event>(
          stream: ref
              .orderByChild("timestamp")
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
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
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
                  ),
                ),
              ],
            );
          }),
    );
  }
}
