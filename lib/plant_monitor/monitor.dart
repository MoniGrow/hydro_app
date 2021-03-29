import 'package:flutter/material.dart';

import 'package:hydro_app/nav_drawer.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Plant monitor"),
      ),
      drawer: Drawer(
        child: NavDrawer(ScreenPaths.monitor),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              HydroOverview(),
              Text("Put"),
              Text("stats"),
              Text("here"),
            ],
          ),
        ),
      ),
    );
  }
}
