import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:hydro_app/home.dart';
import 'package:hydro_app/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HydroApp());
}

class HydroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: "Basil tastes good",
      theme: ThemeData(
        primaryColor: Colors.green[300],
        scaffoldBackgroundColor: Colors.green[200],
        buttonColor: Colors.green[600],
        textTheme: TextTheme(
          headline4: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 32,
          ),
          headline5: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      routes: {
        ScreenPaths.home: (_) => Home(),
      },
    );
  }
}
