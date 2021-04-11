import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/nav_drawer.dart';
import 'package:hydro_app/nav_bottom.dart';
import 'package:hydro_app/plant_monitor/monitor_stat.dart';
import 'package:hydro_app/utils.dart';
import 'package:hydro_app/plant_monitor/hydro_overview.dart';

class Monitor extends StatefulWidget {
  @override
  _MonitorState createState() => _MonitorState();
}

class _MonitorState extends State<Monitor> {
  @override
  Widget build(BuildContext context) {
    Widget monitorBody;
    if (FirebaseAuth.instance.currentUser == null) {
      monitorBody = Center(child: Text("You are not logged in"));
    } else {
      monitorBody = Container(
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant monitor"),
      ),
      drawer: Drawer(
        child: NavDrawer(ScreenPaths.monitor),
      ),
      body: monitorBody,
      bottomNavigationBar: NavBottom(ScreenPaths.monitor),
    );
  }
}
