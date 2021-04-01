import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';
import 'package:hydro_app/title.dart';
import 'package:hydro_app/plant_monitor/monitor.dart';
import 'package:hydro_app/pet_screen/pet_screen_main.dart';
import 'package:hydro_app/plant_monitor/plant_editor.dart';

void main() {
  runApp(HydroApp());
}

class HydroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Basil tastes good",
      routes: {
        ScreenPaths.home: (_) => TitlePage(),
        ScreenPaths.monitor: (_) => Monitor(),
        ScreenPaths.plantEdit: (_) => PlantEditor(),
        ScreenPaths.pet: (_) => PetScreenMain(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
