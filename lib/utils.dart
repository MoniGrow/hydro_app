import 'package:flutter/material.dart';

class Utils {
  /// Returns a list of (x, y) points.
  static List<List<double>> meshCoords(List<double> xArr, List<double> yArr) {
    List<List<double>> mesh = [];
    for (double x in xArr) {
      for (double y in yArr) {
        mesh.add([x, y]);
      }
    }
    return mesh;
  }

  static DateTime dateTimeFromSeconds(dynamic seconds) {
    int ms;
    if (seconds is double) {
      ms = ((seconds) * 1000).round();
    } else if (seconds is int) {
      ms = seconds * 1000;
    } else {
      throw TypeError();
    }
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static dynamic retrieveMapData(Map<dynamic, dynamic> data, dynamic key, {dynamic noneValue}) {
    if (data.containsKey(key)) return data[key];
    return noneValue;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

/// Utility widget to draw a border around some child (for debugging).
class DrawBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double width;

  DrawBorder({
    this.color = Colors.black,
    this.width = 2.0,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: width,
        ),
      ),
      child: child,
    );
  }
}

class ScreenPaths {
  // static const String title = "/";
  static const String home = "/";
  static const String plantEdit = "/edit";
}

class Images {
  static const String cat = "graphics/CAT_IDEA_ROUGH_2_CROPPED.png";
  static const String overview_1 = "graphics/overhead_view_basic.png";
  static const String overview_proto_1 = "graphics/overhead_view_prototype.png";
  static const String profile_blank = "graphics/profile_blank.png";
  static const String question_mark = "graphics/question_mark.png";

  static const String icon_temperature = "graphics/stat_icons/temperature.png";
  static const String icon_waterlevel = "graphics/stat_icons/waterlevel.png";
  static const String icon_humidity = "graphics/stat_icons/humidity.png";
  static const String icon_plant = "graphics/stat_icons/plant.png";
}

class FirebaseConst {
  static const String USER_COLLECTION = "ESP32data";
  static const String SENSOR_DATA_COLLECTION = "sensorData";
  static const String PLANT_DATA_COLLECTION = "grownPlants";
}
