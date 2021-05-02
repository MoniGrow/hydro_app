import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_stat.dart';
import 'package:hydro_app/plant_monitor/hydro_overview.dart';
import 'package:hydro_app/utils.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FirebaseAuth.instance.currentUser == null
        ? Center(child: Text("You are not logged in"))
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [
                  0.8,
                  1,
                ],
                colors: [
                  Colors.indigo[900],
                  Colors.indigo[600],
                ]
              )
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                  child: Text(
                    "Plant Monitor",
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  alignment: Alignment.center,
                  child: HydroOverview(),
                ),
                Container(height: 50),
                MonitorStat("humidity"),
                MonitorStat("temperature"),
              ],
            ),
          );
  }
}
