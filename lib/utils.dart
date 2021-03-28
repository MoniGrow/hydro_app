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
