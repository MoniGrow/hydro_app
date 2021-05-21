import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/utils.dart';

import 'detailed_stats_all.dart';
import 'sortable_series_table.dart';

class DetailedStats extends StatefulWidget {
  final StatType statType;
  final int maxDataPoints;
  final double recentSecondsLimit;

  DetailedStats(this.statType,
      {this.maxDataPoints = 15, this.recentSecondsLimit = 43200});

  @override
  _DetailedStatsState createState() => _DetailedStatsState();
}

class _DetailedStatsState extends State<DetailedStats> {
  List<TimeSeriesStat> dataPoints = [];
  List<charts.Series<TimeSeriesStat, DateTime>> _seriesList;

  Widget generalStat(String label, double stat) {
    return Column(
      children: [
        // TODO overflow error when numbers are too big, need way to shorten
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 21,
              fontWeight: FontWeight.w600,
              fontFamily: "Nunito",
            ),
            children: [
              TextSpan(text: num.parse(stat.toStringAsFixed(2)).toString()),
              TextSpan(
                text: " ${widget.statType.unit}",
                style: TextStyle(
                    color: (stat > widget.statType.upperBoundDefault) ||
                            (stat < widget.statType.lowerBoundDefault)
                        ? Colors.red[700]
                        : Colors.green[600]),
              ),
            ],
          ),
        ),
        Container(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("users/$uid/sensor_data/${widget.statType.fieldName}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.statType.label}",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w400,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => null,
            itemBuilder: (BuildContext context) {
              return {'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
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
            double mean = 0;
            double max = 0;
            double min = double.infinity;
            for (var p in dataPoints) {
              mean += p.stat;
              max = p.stat > max ? p.stat : max;
              min = p.stat < min ? p.stat : min;
            }
            mean /= dataPoints.length;
            double upper = widget.statType.upperBoundDefault;
            double lower = widget.statType.lowerBoundDefault;
            bool tooHigh = (max > upper) || (min > upper);
            bool tooLow = (max < lower) || (min < lower);
            String statusMessage;
            if (tooHigh && tooLow) {
              statusMessage =
                  "Your ${widget.statType.label.toLowerCase()} is fluctuating too much!";
            } else if (tooHigh) {
              statusMessage =
                  "Your ${widget.statType.label.toLowerCase()} is too high!";
            } else if (tooLow) {
              statusMessage =
                  "Your ${widget.statType.label.toLowerCase()} is too low!";
            } else {
              statusMessage = "Your plants are doing fine!";
            }
            return Column(
              children: [
                Text("Displaying recent data"),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 7),
                  height: height * 0.4,
                  child: charts.TimeSeriesChart(
                    _seriesList,
                    animate: true,
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    domainAxis: charts.EndPointsTimeAxisSpec(),
                    defaultRenderer:
                        charts.LineRendererConfig(includeArea: false),
                    primaryMeasureAxis: charts.NumericAxisSpec(
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                            zeroBound: false)),
                    customSeriesRenderers: [
                      charts.PointRendererConfig(customRendererId: 'point'),
                    ],
                    layoutConfig: charts.LayoutConfig(
                      leftMarginSpec: charts.MarginSpec.fixedPixel(40),
                      topMarginSpec: charts.MarginSpec.fixedPixel(20),
                      rightMarginSpec: charts.MarginSpec.fixedPixel(20),
                      bottomMarginSpec: charts.MarginSpec.fixedPixel(20),
                    ),
                    behaviors: [
                      new charts.RangeAnnotation([
                        new charts.RangeAnnotationSegment(
                            widget.statType.lowerBoundDefault,
                            widget.statType.upperBoundDefault,
                            charts.RangeAnnotationAxisType.measure,
                            startLabel: 'min',
                            endLabel: 'max',
                            labelAnchor: charts.AnnotationLabelAnchor.start,
                            color: charts.ColorUtil.fromDartColor(
                                Colors.blue[500].withAlpha(75))),
                      ],
                          defaultLabelPosition:
                              charts.AnnotationLabelPosition.margin),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: width * 0.93,
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(color: Colors.green[50]),
                          child: Row(
                            children: [
                              Spacer(),
                              generalStat("Average", mean),
                              Spacer(),
                              generalStat("High", max),
                              Spacer(),
                              generalStat("Low", min),
                              Spacer(),
                            ],
                          ),
                        ),
                        dataPoints.isEmpty
                            ? Text("No data recorded in the last 12 hours")
                            : Container(
                                alignment: Alignment.center,
                                width: width * 0.85,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Status: $statusMessage",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                        Spacer(),
                        ElevatedButton(
                          child: Text("View all past data"),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).buttonColor),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailedStatsAll(widget.statType),
                              )),
                        ),
                        Spacer(),
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
        id: 'Line',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue[800]),
        areaColorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.blue[400].withAlpha(75)),
        domainFn: (TimeSeriesStat stats, _) => stats.time,
        measureFn: (TimeSeriesStat stats, _) => stats.stat,
        data: dataPoints,
      ),
      charts.Series<TimeSeriesStat, DateTime>(
        id: 'Points',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.teal[800]),
        domainFn: (TimeSeriesStat stats, _) => stats.time,
        measureFn: (TimeSeriesStat stats, _) => stats.stat,
        data: dataPoints,
      )..setAttribute(charts.rendererIdKey, "point"),
    ];
  }
}
