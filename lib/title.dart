import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class TitlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Image cat = Image(
      image: AssetImage(Images.cat),
      fit: BoxFit.scaleDown,
    );
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          children: [
            Spacer(flex: 2),
            Container(
              child: cat,
            ),
            Spacer(flex: 1),
            Container(
              child: ElevatedButton(
                child: Text("Start"),
                onPressed: () =>
                    Navigator.popAndPushNamed(context, ScreenPaths.monitor),
              ),
            ),
            Spacer(flex: 3)
          ],
        ),
      ),
    );
  }
}
