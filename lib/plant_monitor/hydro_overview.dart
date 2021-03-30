import 'package:flutter/material.dart';
import 'package:hydro_app/plant_monitor/cell_popup.dart';

import 'package:hydro_app/utils.dart';

class HydroOverview extends StatelessWidget {
  final SystemLayout layout = SystemLayout.basicLayout();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    BoxDecoration overhead = BoxDecoration(
      image: DecorationImage(
        image: AssetImage("graphics/overhead_view_basic.png"),
        fit: BoxFit.contain,
      ),
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
    );
    double boxWidth = width * 0.8;
    double boxHeight = layout.lockHeight(boxWidth);
    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: overhead,
      child: Stack(
        alignment: Alignment.center,
        children: [...layout.generateButtons(boxWidth / layout.width)],
      ),
      margin: EdgeInsets.only(
        top: 10,
      ),
    );
  }
}

class CellButton extends StatelessWidget {
  final int cell;
  final double size;

  CellButton(this.cell, this.size);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(Icons.circle),
        onPressed: () => Navigator.push(context, CellPopupRoute()),
      ),
    );
  }
}

class SystemLayout {
  String path;
  double width;
  double height;
  double buttonSize;
  List<List<double>> positions;

  SystemLayout.basicLayout() {
    path = "graphics/overhead_view_basic.png";
    width = 778;
    height = 564;
    buttonSize = 110;
    List<double> xMesh = [149, 391, 632];
    List<double> yMesh = [157, 418];
    positions = Utils.meshCoords(xMesh, yMesh);
  }

  double lockHeight(double newWidth) {
    return newWidth * height / width;
  }

  List<Widget> generateButtons(double scale) {
    // this should not be needed, but it is
    int buttonOffset = 4;
    List<Widget> buttons = [];
    for (int i = 0; i < positions.length; i++) {
      List<double> pos = positions[i];
      buttons.add(
        Positioned(
          left: pos[0] * scale - buttonSize * scale / 2 - buttonOffset,
          top: pos[1] * scale - buttonSize * scale / 2 - buttonOffset,
          child: Utils.drawBorder(CellButton(i, buttonSize * scale)),
        ),
      );
    }
    return buttons;
  }
}
