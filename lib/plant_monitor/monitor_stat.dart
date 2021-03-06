import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_utils.dart';

import 'detailed_stats.dart';

class MonitorStat extends StatefulWidget {
  final StatType statType;
  final double buttonHeight;

  MonitorStat(this.statType, {this.buttonHeight = 60});

  @override
  _MonitorStatState createState() => _MonitorStatState();
}

class _MonitorStatState extends State<MonitorStat> {
  String _mostRecent;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String uid = FirebaseAuth.instance.currentUser.uid;
    final DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child("users/$uid/sensor_data/${widget.statType.fieldName}");

    return StreamBuilder<Event>(
        stream: dbRef.orderByChild("timestamp").limitToLast(1).onChildAdded,
        builder: (context, event) {
          String statToPrint;
          bool loading = event.connectionState == ConnectionState.waiting &&
              _mostRecent == null;
          if (event.hasError || loading) {
            if (event.hasError) {
              statToPrint = "Something went wrong!";
            } else if (loading) {
              statToPrint = "Loading...";
            }
          } else {
            if (event.hasData) {
              dynamic retrieved =
                  event.data.snapshot.value[widget.statType.fieldName];
              if (retrieved is double) {
                _mostRecent =
                    num.parse(retrieved.toStringAsFixed(2)).toString();
              } else {
                _mostRecent = retrieved.toString();
              }
            } else {
              print("Query snapshot is empty");
            }
            statToPrint =
                _mostRecent != null ? _mostRecent : "No data recorded";
          }
          Widget button = ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: widget.statType.bgColor,
            ),
            child: Row(
              children: [
                widget.statType.getIcon(widget.buttonHeight * 0.7),
                Container(width: 10),
                Text(
                  widget.statType.label,
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Text(
                  "$statToPrint ${widget.statType.unit}",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontFamily: "Nunito",
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailedStats(widget.statType)));
            },
          );
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: width * 0.9,
            height: widget.buttonHeight,
            child: button,
          );
        });
  }
}
