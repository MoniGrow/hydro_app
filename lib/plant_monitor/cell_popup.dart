import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void retrievePlant() async {
    // todo cache this probably maybe
    String uid = FirebaseAuth.instance.currentUser.uid;
    Query plants = FirebaseFirestore.instance
        .collection(FirebaseConst.USER_COLLECTION)
        .doc(uid)
        .collection(FirebaseConst.PLANT_DATA_COLLECTION)
        .where("cell_num", isEqualTo: widget.cell);

    await plants.get().then((snapshot) {
      if (snapshot.size == 0) return;
      setState(() {
        plantData = snapshot.docs.first.data();
      });
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
                    builder: (_) => PlantEditor(plantData),
                  ))),
        ),
      ],
    );
    Widget popupBody;
    if (plantData != null) {
      popupBody = Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 15),
                  width: 75,
                  height: 75,
                  child: Image(
                    image: plantData.containsKey("image_url")
                        ? NetworkImage(plantData["image_url"])
                        : AssetImage(Images.question_mark),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
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
              ],
            ),
            Text("Cell ${widget.cell}"),
            Spacer(),
            Text(plantData.containsKey("time_planted")
                ? "Time planted: ${(plantData['time_planted'] as Timestamp).toDate().toString()}"
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
            Text("No plant stored yet"),
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
