import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/utils.dart';

class PlantEditor extends StatefulWidget {
  final Map<String, dynamic> preExisting;
  final int cell;
  final void Function() updateOnConfirm;

  PlantEditor(this.preExisting, this.cell, this.updateOnConfirm);

  @override
  _PlantEditorState createState() => _PlantEditorState();
}

class _PlantEditorState extends State<PlantEditor> {
  final _formKey = GlobalKey<FormState>();

  String _hour = "00";
  String _minute = "00";
  String _time = "00:00";
  String img_url = "";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  void setFromPlantData(Map<dynamic, dynamic> data) {
    _nameController.text = data["name"];
    img_url = data["image_url"];
  }

  void setTimeFields(DateTime time) {
    selectedDate = time;
    selectedTime = TimeOfDay.fromDateTime(time);
    _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    _hour = selectedTime.hour.toString();
    _minute = selectedTime.minute.toString();
    _time = _hour.padLeft(2, "0") + ' : ' + _minute.padLeft(2, "0");
    _timeController.text = _time;
  }

  @override
  void initState() {
    super.initState();
    if (widget.preExisting != null) {
      DateTime timestamp =
          Utils.dateTimeFromSeconds(widget.preExisting["time_planted"]);
      setTimeFields(timestamp);
      _nameController.text = widget.preExisting["plant_name"];
    }
  }

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
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour.padLeft(2, "0") + ' : ' + _minute.padLeft(2, "0");
        _timeController.text = _time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo image upload?
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new plant"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlantSearchDelegate(setFromPlantData),
              );
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Plant name"),
                      Container(width: 5),
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
                      "cell${widget.cell}": {
                        "cell_num": widget.cell,
                        "image_url": img_url,
                        "plant_name": plantName,
                        "time_planted":
                            parsedTime.millisecondsSinceEpoch.toDouble() / 1000
                      }
                    };
                    String uid = FirebaseAuth.instance.currentUser.uid;
                    FirebaseDatabase.instance
                        .reference()
                        .child("users/$uid/grown_plants")
                        .update(data);
                    widget.updateOnConfirm();
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

class PlantSearchDelegate extends SearchDelegate {
  List<Map<dynamic, dynamic>> plants = [];
  final void Function(Map) selectedFunc;

  PlantSearchDelegate(this.selectedFunc) {
    loadPlants();
  }

  void loadPlants() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("plant_data");
    await ref.once().then((snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic>.from(snapshot.value).forEach((_, value) {
          plants.add(value);
        });
      } else {
        print("No data from plants loaded. Something went wrong.");
      }
      print(plants);
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget buildSearchColumn() {
    if (query.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Type a name of a plant!",
            ),
          )
        ],
      );
    }

    if (plants.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    var filtered = plants.where((plant) =>
        plant["name"].toString().toLowerCase().contains(query.toLowerCase()));
    if (filtered.length == 0) {
      return Column(
        children: <Widget>[
          Text(
            "No Results Found.",
          ),
        ],
      );
    }
    var filteredList = filtered.toList();
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        var result = filteredList[index]["name"];
        return ListTile(
          title: Text(result),
          onTap: () {
            selectedFunc(filteredList[index]);
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchColumn();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchColumn();
  }
}
