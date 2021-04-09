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
  static const String home = "/";

  static const String monitor = "/monitor";
  static const String plantEdit = monitor + "/edit";

  static const String pet = "/pet";
  static const String pet_customize = pet + "/customize";

  static const String profile = "/profile";
}

class Images {
  static const String cat = "graphics/CAT_IDEA_ROUGH_2_CROPPED.png";
  static const String overview_1 = "graphics/overhead_view_basic.png";
  static const String qb = "graphics/qb.jpg";
  static const String profile_blank = "graphics/profile_blank.png";

  static const String brain = "graphics/brain.jpg";
  static const String tree = "graphics/tree.jpeg";
  static const String shopfront = "graphics/shopfront.jpg";

  static const String plant_basil = "graphics/plants/basil.jpg";
  static const String plant_cilantro = "graphics/plants/cilantro.jpg";
  static const String plant_rosemary = "graphics/plants/rosemary.jpg";
}
