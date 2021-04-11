import 'dart:async';
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
  String _dataVal;
  Timer _valueTimer;
  String _mostRecent;

  _MonitorStatState();

  @override
  void initState() {
    super.initState();

    _dataVal = rng.nextInt(80).toString();
    _valueTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          _dataVal = rng.nextInt(80).toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    CollectionReference data = FirebaseFirestore.instance
        .collection(FirebaseConst.USER_COLLECTION)
        .doc(uid)
        .collection(FirebaseConst.SENSOR_DATA_COLLECTION);

    return StreamBuilder<QuerySnapshot>(
        stream: data.snapshots(),
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
          // order_by on data snapshots for some reason makes every query
          // fucking empty so we have to sort this shit like this
          snapshot.data.docs.sort((a, b) {
            Timestamp timeA = a.data()["timestamp"] as Timestamp;
            Timestamp timeB = b.data()["timestamp"] as Timestamp;
            return timeA.compareTo(timeB);
          });
          _mostRecent =
              snapshot.data.docs.last.data()[widget.fieldName].toString();
          return TextButton(
            child: Text(
                (widget.label == null ? widget.fieldName : widget.label) +
                    ": " +
                    _mostRecent),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => DetailedStats()));
            },
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _valueTimer.cancel();
  }
}
