import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/utils.dart';
import 'package:hydro_app/title.dart';
import 'package:hydro_app/plant_monitor/monitor.dart';
import 'package:hydro_app/plant_monitor/plant_editor.dart';
import 'package:hydro_app/pet_screen/pet_screen_main.dart';
import 'package:hydro_app/pet_screen/pet_customize_main.dart';
import 'package:hydro_app/profile_settings/profile_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ScreenPaths.pet_customize: (_) => PetCustomizeMain(),
        ScreenPaths.profile: (_) => ProfileMain(FirebaseAuth.instance.currentUser),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
