import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

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

// todo fancier popup that is not just a rectangle
// also todo make it scrollable
class CellPopup extends StatelessWidget {
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
      // constraints: BoxConstraints.expand(),
      child: Column(
        children: [
          Row(
            children: [
              Text("hey hey hey"),
            ],
          ),
          Spacer(),
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
