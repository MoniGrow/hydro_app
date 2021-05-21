import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydro_app/plant_monitor/monitor_utils.dart';
import 'package:hydro_app/plant_monitor/plant_editor.dart';

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

class CellPopup extends StatefulWidget {
  final int cell;

  CellPopup(this.cell);

  @override
  _CellPopupState createState() => _CellPopupState();
}

class _CellPopupState extends State<CellPopup> {
  Map<String, dynamic> plantData;
  bool _loading = true;

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
            _loading = false;
          });
        });
      } else {
        setState(() {
          _loading = false;
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
    double width = MediaQuery.of(context).size.width;
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
                    builder: (_) =>
                        PlantEditor(plantData, widget.cell, retrievePlant),
                  ))),
        ),
      ],
    );
    Widget popupBody;
    if (plantData != null) {
      DateTime timePlanted =
          Utils.dateTimeFromSeconds(plantData["time_planted"]);
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
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Text(
                          plantData.containsKey("plant_name")
                              ? plantData["plant_name"].toString().capitalize()
                              : "Plant name missing",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Cell ${widget.cell}"),
                        Text(
                            "Age: ${DateTime.now().difference(timePlanted).inDays} days"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(flex: 1),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 250,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 1),
              ),
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Text(
                      "Additional information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(height: 10),
                    Text(
                      plantData.containsKey("time_planted")
                          ? "Time planted: ${timePlanted.toString().split(".")[0]}"
                          : "Time planted unknown",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(height: 10),
                    Text(
                      plantData.containsKey("temp_min") &&
                              plantData.containsKey("temp_max")
                          ? "Ideal temperature range: ${plantData["temp_min"]}-"
                              "${plantData["temp_max"]} ${StatType.temperature().unit}"
                          : "Idea temperature range unknown",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(height: 10),
                    Text(plantData.containsKey("description")
                        ? plantData["description"]
                        : ""),
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
            buttonRow,
          ],
        ),
      );
    } else if (plantData == null && !_loading) {
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
    } else {
      popupBody = Center(
        child: Column(
          children: [
            Spacer(),
            Text("Loading..."),
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
