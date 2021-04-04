import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Image cat = Image(
      image: AssetImage(Images.cat),
      fit: BoxFit.contain,
    );
    Function leaveHome = (path) {
      Navigator.popAndPushNamed(context, path);
    };
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
                onPressed: () => leaveHome(ScreenPaths.monitor),
              ),
            ),
            ElevatedButton(
              child: Text("Pet"),
              onPressed: () => leaveHome(ScreenPaths.pet),
            ),
          ],
        ),
      ),
    );
  }
}