import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/plant_monitor/hydro_overview.dart';
import 'package:hydro_app/utils.dart';
import 'monitor_stat.dart';

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
        // color: Colors.green[300],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            // Colors.white,
            Theme.of(context).scaffoldBackgroundColor,
          ],
          stops: [0.3, 1],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(top: 15, left: 15, bottom: 10),
              child: Text(
                "Plant Monitor",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 15),
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.all(Radius.circular(10)),
                // border: Border.all(width: 1),
              ),
              alignment: Alignment.center,
              child: HydroOverview(),
            ),
            Container(height: 20),
            MonitorStat(StatType.waterlevel()),
            MonitorStat(StatType.humidity()),
            MonitorStat(StatType.temperature()),
          ],
        ),
      ),
    );
  }
}
