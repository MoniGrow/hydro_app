import 'package:flutter/material.dart';

class CellPopupRoute extends PopupRoute {
  @override
  Color get barrierColor => Colors.black.withAlpha(150);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CellPopup();
  }

  @override
  Duration get transitionDuration => Duration();
}

class CellPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.all(45),
        color: Colors.white,
        child: Text("hello there"),
      ),
    );
  }
}
