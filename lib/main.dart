import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:hydro_app/home.dart';
import 'package:hydro_app/utils.dart';
import 'package:hydro_app/title.dart';

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
        ScreenPaths.title: (_) => TitlePage(),
        ScreenPaths.home: (_) => Home(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
