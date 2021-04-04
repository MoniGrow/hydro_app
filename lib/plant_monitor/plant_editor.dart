import 'package:flutter/material.dart';

class PlantEditor extends StatefulWidget {
  @override
  _PlantEditorState createState() => _PlantEditorState();
}

class _PlantEditorState extends State<PlantEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new plant"),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Search plant",
            ),
          ),
        ],
      ),
    );
  }
}
