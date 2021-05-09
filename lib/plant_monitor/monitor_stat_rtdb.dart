import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/detailed_stats.dart';
import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/utils.dart';

/// Lot's of duplication with MonitorStat but hey whatever
class MonitorStatRTDB extends StatefulWidget {
  final StatType statType;
  final double buttonHeight;

  MonitorStatRTDB(this.statType, {this.buttonHeight = 60});

  @override
  _MonitorStatState createState() => _MonitorStatState();
}

class _MonitorStatState extends State<MonitorStatRTDB> {
  String _mostRecent;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String uid = FirebaseAuth.instance.currentUser.uid;
    final DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child("users/$uid/sensor_data");

    return StreamBuilder<Event>(
        stream: dbRef
            .child(widget.statType.fieldName)
            .orderByChild("timestamp")
            .limitToLast(1)
            .onChildAdded,
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
                Image.asset(
                  widget.statType.iconPath,
                  height: widget.buttonHeight * 0.7,
                ),
                Container(width: 10),
                Text(
                  widget.statType.label,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Spacer(),
                Text(
                  "$statToPrint ${widget.statType.unit}",
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 16,
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
