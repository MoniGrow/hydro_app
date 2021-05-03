import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class StatType {
  String fieldName;
  String label;
  Color bgColor;
  String iconPath;
  String unit;

  StatType.temperature() {
    fieldName = "temperature";
    label = "Temperature";
    bgColor = Colors.amber[200];
    iconPath = Images.icon_temperature;
    unit = "°F";
  }

  StatType.waterlevel() {
    fieldName = "waterlevel";
    label = "Water Level";
    bgColor = Colors.blue[100];
    iconPath = Images.icon_waterlevel;
    unit = "in";
  }
}
