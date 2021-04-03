import 'package:flutter/material.dart';

class Utils {
  static List<List<double>> meshCoords(List<double> xArr, List<double> yArr) {
    List<List<double>> mesh = [];
    for (double x in xArr) {
      for (double y in yArr) {
        mesh.add([x, y]);
      }
    }
    return mesh;
  }

  static Container drawBorder(Widget child,
      [Color color = Colors.black, double width = 2]) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}

class ScreenPaths {
  static const String home = "/";
  static const String monitor = "/monitor";
  static const String plantEdit = monitor + "/edit";
  static const String pet = "/pet";
}

class Images {
  static const String cat = "graphics/CAT_IDEA_ROUGH_2_CROPPED.png";
  static const String overview_1 = "graphics/overhead_view_basic.png";

  static const String plant_basil = "graphics/plants/basil.jpg";
  static const String plant_cilantro = "graphics/plants/cilantro.jpg";
  static const String plant_rosemary = "graphics/plants/rosemary.jpg";
}
