import 'package:flutter/material.dart';

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
  double _currTemperature;
  double _currPh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant monitor"),
      ),
      drawer: Drawer(
        child: NavDrawer(ScreenPaths.monitor),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: HydroOverview(),
            ),
            MonitorStat("light"),
            MonitorStat("temperature"),
            MonitorStat("pH"),
          ],
        ),
      ),
      bottomNavigationBar: NavBottom(ScreenPaths.monitor),
    );
  }
}
