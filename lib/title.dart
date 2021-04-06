import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Image cat = Image(
      image: AssetImage(Images.cat),
      fit: BoxFit.scaleDown,
    );
    Function leaveHome = (path) {
      Navigator.popAndPushNamed(context, path);
    };
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: [
            Spacer(flex:4),
            Container(
              child:cat,
            ),
            Spacer(flex:4),
            Container(
              child: ElevatedButton(
                child: Text("Plant monitor"),
                onPressed: () => leaveHome(ScreenPaths.monitor),
              ),
            ),
           // Spacer(flex:1),
            ElevatedButton(
              child: Text("Pet"),
              onPressed: () => leaveHome(ScreenPaths.pet),
            ),
            Spacer(flex:3)
          ],
        ),
      ),
    );
  }
}