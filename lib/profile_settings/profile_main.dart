import 'package:flutter/material.dart';

import 'package:hydro_app/nav_bottom.dart';
import 'package:hydro_app/utils.dart';

class ProfileMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 30, bottom: 50 , left: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(Images.profile_blank),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text("First name Last name"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text("Edit profile"),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: Text("Settings"),
                    onPressed: null,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: NavBottom(ScreenPaths.profile),
    );
  }
}
