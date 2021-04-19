import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_stat.dart';
import 'package:hydro_app/plant_monitor/hydro_overview.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Center(child: Text("You are not logged in"))
        : Container(
            child: Column(
              children: <Widget>[
                Center(
                  child: HydroOverview(),
                ),
                MonitorStat("humidity"),
                MonitorStat("temperature"),
              ],
            ),
          );
  }
}
