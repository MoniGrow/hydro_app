import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class CellPopupRoute extends PopupRoute {
  @override
  Color get barrierColor => Colors.black.withAlpha(150);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  final int cell;

  CellPopupRoute(this.cell);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CellPopup(cell);
  }

  @override
  Duration get transitionDuration => Duration();
}

class CellPopup extends StatelessWidget {
  final int cell;

  CellPopup(this.cell);

  @override
  Widget build(BuildContext context) {
    Widget buttonRow = Row(
      children: [
        IconButton(
          icon: Icon(Icons.cancel_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.only(right: 10),
          child: OutlinedButton(
            child: Text("Edit plant"),
            onPressed: () =>
                Navigator.pushNamed(context, ScreenPaths.plantEdit),
          ),
        ),
      ],
    );
    Widget popupBody = Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 15),
                width: 75,
                height: 75,
                child: Image(
                  image: AssetImage(Images.plant_basil),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 45, top: 10),
                child: Text(
                  "Basil",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text("Cell $cell"),
          Spacer(),
          Text("Time planted: 11/23/2017 15:23:18"),
          Spacer(),
          Text("Age: 118 hours"),
          Spacer(
            flex: 3,
          ),
          buttonRow,
        ],
      ),
    );

    return SafeArea(
      child: Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.all(45),
        color: Colors.white,
        child: Scaffold(
          body: popupBody,
        ),
      ),
    );
  }
}
