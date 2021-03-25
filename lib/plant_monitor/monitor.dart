import 'package:flutter/material.dart';

import 'hydro_overview.dart';

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Drawer Header"),
            ),
            ListTile(
              title: Text("Item 1"),
              onTap: null,
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: HydroOverview(),
                margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              ),
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
