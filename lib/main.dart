import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';
import 'package:hydro_app/plant_monitor/monitor.dart';

void main() {
  runApp(HydroApp());
}

class HydroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Basil tastes good",
      routes: {
        ScreenPaths.home: (context) => TitlePage(),
        ScreenPaths.monitor: (context) => Monitor(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Image cat = Image(
      image: AssetImage("graphics/CAT_IDEA_ROUGH_2_CROPPED.png"),
      fit: BoxFit.contain,
    );
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: FractionallySizedBox(
                child: cat,
                widthFactor: 0.5,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 100),
              child: ElevatedButton(
                child: Text("Plant monitor"),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/monitor",
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text("Pet"),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
