import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/utils.dart';

class PlantEditor extends StatefulWidget {
  final Map<String, dynamic> preExisting;

  PlantEditor(this.preExisting);

  @override
  _PlantEditorState createState() => _PlantEditorState();
}

class _PlantEditorState extends State<PlantEditor> {
  final _formKey = GlobalKey<FormState>();

  String _hour = "00";
  String _minute = "00";
  String _time = "00:00";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour.padLeft(2, "0") + ' : ' + _minute.padLeft(2, "0");
        _timeController.text = _time;
      });
  }

  @override
  Widget build(BuildContext context) {
    // todo image upload?
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new plant"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Search plant (does nothing)",
                    ),
                  ),
                  Row(
                    children: [
                      Text("Plant name"),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a name";
                            }
                            return null;
                          },
                          controller: _nameController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("${selectedDate.toLocal()}".split(' ')[0]),
                            ElevatedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select date'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(_time),
                            ElevatedButton(
                              onPressed: () => _selectTime(context),
                              child: Text('Select time'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.only(right: 10, bottom: 10),
              child: ElevatedButton(
                child: Text("Confirm plant"),
                onPressed: () {
                  // todo validate time so it's not in the future
                  // todo timezone crap
                  if (_formKey.currentState.validate()) {
                    String plantName = _nameController.text;
                    DateTime parsedTime = selectedDate.add(Duration(
                        hours: selectedTime.hour,
                        minutes: selectedTime.minute));
                    var data = {
                      "cell_num": widget.preExisting["cell_num"],
                      "plant_name": plantName,
                      "time_planted": Timestamp.fromDate(parsedTime)
                    };
                    String uid = FirebaseAuth.instance.currentUser.uid;
                    CollectionReference plants = FirebaseFirestore.instance
                        .collection(FirebaseConst.USER_COLLECTION)
                        .doc(uid)
                        .collection(FirebaseConst.PLANT_DATA_COLLECTION);
                    plants
                        .where("cell_num",
                            isEqualTo: widget.preExisting["cell_num"])
                        .get()
                        .then((snapshot) {
                      if (snapshot.size == 0) {
                        plants
                            .doc(widget.preExisting["cell_num"].toString())
                            .set(data);
                      } else {
                        plants.doc(snapshot.docs.first.id).set(data);
                      }
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
