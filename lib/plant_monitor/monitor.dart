import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_utils.dart';
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
    if (FirebaseAuth.instance.currentUser == null) {
      return Center(child: Text("You are not logged in"));
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [
            0.8,
            1,
          ],
          colors: [
            Colors.blue[50],
            Colors.lightBlue[100],
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(top: 10, left: 15, bottom: 10),
            child: Text(
              "Plant Monitor",
              style: TextStyle(
                color: Colors.grey[850],
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            width: width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2),
            ),
            alignment: Alignment.center,
            child: HydroOverview(),
          ),
          Container(height: 50),
          MonitorStat(StatType.waterlevel()),
          MonitorStat(StatType.temperature()),
        ],
      ),
    );
  }
}
