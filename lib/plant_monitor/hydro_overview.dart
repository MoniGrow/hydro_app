import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';
import 'package:hydro_app/plant_monitor/cell_popup.dart';

class HydroOverview extends StatelessWidget {
  final SystemLayout layout = SystemLayout.prototypeLayout();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    BoxDecoration overhead = BoxDecoration(
      image: DecorationImage(
        image: AssetImage(layout.path),
        fit: BoxFit.contain,
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
        children: layout.generateButtons(boxWidth / layout.width),
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
        icon: Icon(
          Icons.circle,
          color: Colors.grey[800],
        ),
        onPressed: () => Navigator.push(context, CellPopupRoute(cell)),
      ),
    );
  }
}

class SystemLayout {
  String path;
  double buttonOffsets;
  double width;
  double height;
  double buttonSize;
  List<List<double>> positions;

  SystemLayout.basicLayout() {
    path = Images.overview_1;
    buttonOffsets = 0;
    width = 778;
    height = 564;
    buttonSize = 110;
    List<double> xMesh = [149, 391, 632];
    List<double> yMesh = [157, 418];
    positions = Utils.meshCoords(xMesh, yMesh);
  }

  SystemLayout.prototypeLayout() {
    path = Images.overview_proto_1;
    buttonOffsets = 0;
    width = 1018;
    height = 409;
    buttonSize = 140;
    var row1 = Utils.meshCoords([122, 320, 513, 709, 904], [114]);
    var row2 = Utils.meshCoords([128, 308, 722, 903], [298]);
    row1.addAll(row2);
    positions = row1;
  }

  double lockHeight(double newWidth) {
    return newWidth * height / width;
  }

  List<Widget> generateButtons(double scale) {
    // this should not be needed, but it is
    List<Widget> buttons = [];
    for (int i = 1; i <= positions.length; i++) {
      List<double> pos = positions[i - 1];
      buttons.add(
        Positioned(
          left: pos[0] * scale - buttonSize * scale / 2 - buttonOffsets,
          top: pos[1] * scale - buttonSize * scale / 2 - buttonOffsets,
          child: CellButton(i, buttonSize * scale),
        ),
      );
    }
    return buttons;
  }
}
