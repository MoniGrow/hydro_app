import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/detailed_stats.dart';
import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/utils.dart';

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
    CollectionReference data = FirebaseFirestore.instance
        .collection(FirebaseConst.USER_COLLECTION)
        .doc(uid)
        .collection(FirebaseConst.SENSOR_DATA_COLLECTION);

    return StreamBuilder<QuerySnapshot>(
        // VERY IMPORTANT NOTE: the collection needs to have a composite index
        // build on it in order to use orderBy, or else it just returns empty
        // queries
        stream:
            data.orderBy("timestamp", descending: true).limit(1).snapshots(),
        builder: (context, snapshot) {
          String statToPrint;
          bool loading = snapshot.connectionState == ConnectionState.waiting &&
              _mostRecent == null;
          if (snapshot.hasError || loading) {
            if (snapshot.hasError) {
              statToPrint = "Something went wrong!";
            } else if (loading) {
              statToPrint = "Loading...";
            }
          } else {
            if (snapshot.data.docs.isNotEmpty) {
              dynamic retrieved =
                  snapshot.data.docs.first.data()[widget.statType.fieldName];
              if (retrieved is double) {
                _mostRecent =
                    num.parse(retrieved.toStringAsFixed(2)).toString();
              } else {
                _mostRecent =
                    retrieved.toString();
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
