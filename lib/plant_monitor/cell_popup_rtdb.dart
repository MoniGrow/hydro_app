import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydro_app/plant_monitor/plant_editor_rtdb.dart';

import 'package:hydro_app/utils.dart';

class CellPopupRouteRTDB extends PopupRoute {
  @override
  Color get barrierColor => Colors.black.withAlpha(150);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  final int cell;

  CellPopupRouteRTDB(this.cell);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return CellPopupRTDB(cell);
  }

  @override
  Duration get transitionDuration => Duration();
}

class CellPopupRTDB extends StatefulWidget {
  final int cell;

  CellPopupRTDB(this.cell);

  @override
  _CellPopupStateRTDB createState() => _CellPopupStateRTDB();
}

class _CellPopupStateRTDB extends State<CellPopupRTDB> {
  Map<String, dynamic> plantData;

  void retrievePlant() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("users/$uid/grown_plants");
    // very major note: do not set the key of the cell to 1, it's cursed
    // when queried for some reason
    await ref
        .orderByChild("cell_num")
        .limitToLast(1)
        .equalTo(widget.cell)
        .once()
        .then((snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic>.from(snapshot.value).forEach((key, value) {
          setState(() {
            plantData = Map<String, dynamic>.from(value);
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    retrievePlant();
  }

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
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlantEditorRTDB(plantData, widget.cell),
                  ))),
        ),
      ],
    );
    Widget popupBody;
    if (plantData != null) {
      int ms;
      if (plantData["time_planted"] is int) {
        ms = plantData["time_planted"] * 1000;
      } else {  // data is a double
        ms = ((plantData["time_planted"] as double) * 1000).round();
      }
      DateTime timePlanted = DateTime.fromMillisecondsSinceEpoch(ms);
      popupBody = Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15),
                  width: 75,
                  height: 75,
                  child: FadeInImage(
                    placeholder: AssetImage(Images.question_mark),
                    image: plantData.containsKey("image_url")
                        ? NetworkImage(plantData["image_url"])
                        : AssetImage(Images.question_mark),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 45, top: 10),
                    child: Text(
                      plantData.containsKey("plant_name")
                          ? plantData["plant_name"]
                          : "Plant name missing",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text("Cell ${widget.cell}"),
            Spacer(),
            Text(plantData.containsKey("time_planted")
                ? "Time planted: $timePlanted"
                : "Time planted unknown"),
            Spacer(),
            Text("Age: idk yet"),
            Spacer(
              flex: 3,
            ),
            buttonRow,
          ],
        ),
      );
    } else {
      popupBody = Center(
        child: Column(
          children: [
            Spacer(),
            Text("Cell ${widget.cell}: No plant stored yet"),
            Spacer(),
            buttonRow,
          ],
        ),
      );
    }

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
