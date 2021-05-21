import 'dart:math';

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

  final double tempMinDefault = 50;
  final double tempMaxDefault = 80;

  String _hour = "00";
  String _minute = "00";
  String _time = "00:00";
  String img_url = "";

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _tempMinController = TextEditingController();
  TextEditingController _tempMaxController = TextEditingController();

  void setFromPlantData(Map<dynamic, dynamic> data) {
    if (data.containsKey("plant_name")) {
      _nameController.text =
          Utils.retrieveMapData(data, "plant_name", noneValue: "");
    } else {
      _nameController.text = Utils.retrieveMapData(data, "name", noneValue: "");
    }
    _tempMinController.text =
        Utils.retrieveMapData(data, "temp_min", noneValue: tempMinDefault)
            .toString();
    _tempMaxController.text =
        Utils.retrieveMapData(data, "temp_max", noneValue: tempMaxDefault)
            .toString();
    setState(() {
      img_url = Utils.retrieveMapData(data, "image_url", noneValue: "");
    });
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
      DateTime timestamp = Utils.dateTimeFromSeconds(Utils.retrieveMapData(
          widget.preExisting, "time_planted",
          noneValue: DateTime.now().millisecondsSinceEpoch / 1000));
      setTimeFields(timestamp);
      setFromPlantData(widget.preExisting);
    } else {
      _tempMinController.text = tempMinDefault.toString();
      _tempMaxController.text = tempMaxDefault.toString();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 1),
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

  Function getEmptyValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Enter a name";
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Plant name:", style: labelStyle),
                        Container(width: 5),
                        Expanded(
                          child: TextFormField(
                            validator: getEmptyValidator("Enter a name"),
                            controller: _nameController,
                          ),
                        ),
                        Column(
                          children: [
                            img_url.isEmpty
                                ? Container()
                                : ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 75),
                                    child: Image(
                                      image: NetworkImage(img_url),
                                      width: 75,
                                    ),
                                  ),
                            ElevatedButton(
                                onPressed: null, child: Text("Upload a photo"))
                          ],
                        ),
                      ],
                    ),
                    Container(height: 10),
                    Text("Time planted:", style: labelStyle),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text("${selectedDate.toLocal()}".split(' ')[0]),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: Text('Select date'),
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).buttonColor),
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
                                style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).buttonColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Min temperature"),
                        Expanded(
                          child: TextFormField(
                            validator:
                                getEmptyValidator("Enter a temperature (F)"),
                            controller: _tempMinController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Text("Max temperature"),
                        Expanded(
                          child: TextFormField(
                            validator:
                                getEmptyValidator("Enter a temperature (F)"),
                            controller: _tempMaxController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Text("Confirm plant"),
        style: ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor),
        onPressed: () {
          // todo validate time so it's not in the future
          // todo timezone crap
          if (_formKey.currentState.validate()) {
            String plantName = _nameController.text;
            DateTime parsedTime = selectedDate.add(Duration(
                hours: selectedTime.hour, minutes: selectedTime.minute));
            var data = {
              "cell${widget.cell}": {
                "cell_num": widget.cell,
                "image_url": img_url,
                "plant_name": plantName,
                "time_planted":
                    parsedTime.millisecondsSinceEpoch.toDouble() / 1000,
                "temp_min": double.parse(_tempMinController.text),
                "temp_max": double.parse(_tempMaxController.text),
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
      print("Plant database received");
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
      var allSliced = plants.sublist(0, min(20, plants.length));
      return ListView.builder(
        itemCount: allSliced.length,
        itemBuilder: (context, index) {
          var result = allSliced[index]["name"];
          return ListTile(
            title: Text(result),
            onTap: () {
              selectedFunc(allSliced[index]);
              close(context, null);
            },
          );
        },
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
        children: [
          Container(height: 10),
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

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
}
