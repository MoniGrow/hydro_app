import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydro_app/plant_monitor/detailed_stats.dart';

class MonitorStat extends StatefulWidget {
  final String dataType;

  MonitorStat(this.dataType);

  @override
  _MonitorStatState createState() => _MonitorStatState(dataType);
}

class _MonitorStatState extends State<MonitorStat> {
  final String dataType;
  Random rng = Random();
  String _dataVal;
  Timer _valueTimer;

  _MonitorStatState(this.dataType);

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
    return TextButton(
      child: Text(dataType + ": " + _dataVal),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailedStats()));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _valueTimer.cancel();
  }
}
