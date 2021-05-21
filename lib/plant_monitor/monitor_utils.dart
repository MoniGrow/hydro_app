import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class StatType {
  /// The name of the field/key corresponding to this data type
  final String fieldName;

  /// How you would actually write this type of data in english
  final String label;
  final Color bgColor;
  final Widget Function(double) getIcon;
  final String unit;
  final double lowerBoundDefault;
  final double upperBoundDefault;

  StatType(
      {@required this.fieldName,
      this.label,
      this.bgColor,
      this.getIcon,
      this.unit,
      this.lowerBoundDefault,
      this.upperBoundDefault});

  factory StatType.temperature() {
    return StatType(
      fieldName: "temperature",
      label: "Temperature",
      bgColor: Colors.amber[200],
      getIcon: (size) => ImageIcon(
        AssetImage(Images.icon_temperature),
        color: Colors.grey[900],
        size: size,
      ),
      unit: "°F",
      lowerBoundDefault: 50,
      upperBoundDefault: 80,
    );
  }

  factory StatType.waterlevel() {
    return StatType(
      fieldName: "water_level",
      label: "Water Level",
      bgColor: Colors.blue[100],
      getIcon: (size) => ImageIcon(
        AssetImage(Images.icon_waterlevel),
        color: Colors.grey[900],
        size: size,
      ),
      unit: "in",
      lowerBoundDefault: 6,
      upperBoundDefault: 7,
    );
  }

  factory StatType.humidity() {
    return StatType(
      fieldName: "humidity",
      label: "Humidity",
      bgColor: Colors.blue[200],
      getIcon: (size) => ImageIcon(
        AssetImage(Images.icon_humidity),
        color: Colors.grey[900],
        size: size,
      ),
      unit: "%rh",
      lowerBoundDefault: 70,
      upperBoundDefault: 90,
    );
  }
}

/// Sample time series data type.
class TimeSeriesStat {
  final DateTime time;
  final double stat;

  TimeSeriesStat(this.time, this.stat);

  @override
  String toString() {
    return "{$time: $stat}";
  }
}
