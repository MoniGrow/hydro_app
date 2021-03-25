import 'package:flutter/material.dart';

import 'plant_monitor/monitor.dart';

void main() {
  runApp(HydroApp());
}

class HydroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Basil tastes good",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TitlePage(),
    );
  }
}

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Image cat = Image(
      image: AssetImage("graphics/CAT_IDEA_ROUGH_2_CROPPED.png"),
      fit: BoxFit.contain,
    );
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: [
            FractionallySizedBox(
              child: cat,
              widthFactor: 0.5,
            ),
            Container(
              padding: EdgeInsets.only(top: 100),
              child: ElevatedButton(
                child: Text("Plant monitor"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Monitor()),
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
