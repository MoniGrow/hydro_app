import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/detailed_stats.dart';
import 'package:hydro_app/utils.dart';

class MonitorStat extends StatefulWidget {
  final String fieldName;
  final String label;

  MonitorStat(this.fieldName, {this.label});

  @override
  _MonitorStatState createState() => _MonitorStatState();
}

class _MonitorStatState extends State<MonitorStat> {
  Random rng = Random();
  String _mostRecent;

  @override
  Widget build(BuildContext context) {
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
          if (snapshot.hasError) {
            return Text(
                (widget.label == null ? widget.fieldName : widget.label) +
                    ": Something went wrong!");
          }
          if (snapshot.connectionState == ConnectionState.waiting &&
              _mostRecent == null) {
            return Text(
                (widget.label == null ? widget.fieldName : widget.label) +
                    ": Loading...");
          }
          if (snapshot.data.docs.isNotEmpty) {
            _mostRecent =
                snapshot.data.docs.first.data()[widget.fieldName].toString();
          } else {
            print("Query snapshot is empty, something went wrong");
          }
          return TextButton(
            child: Text(
                (widget.label == null ? widget.fieldName : widget.label) +
                    ": " +
                    _mostRecent),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailedStats(widget.fieldName)));
            },
          );
        });
  }
}
