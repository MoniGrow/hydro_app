import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:hydro_app/nav_bottom.dart';
import 'package:hydro_app/utils.dart';
import 'package:hydro_app/profile_settings/google_auth_buttons.dart';

class ProfileMain extends StatelessWidget {
  final User user;

  ProfileMain(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO keeping this stateless shouldn't be too bad right?
    ImageProvider pfp;
    String name;
    if (user != null) {
      pfp = NetworkImage(user.photoURL);
      name = user.displayName;
    } else {
      pfp = AssetImage(Images.profile_blank);
      name = "User";
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(left: 20),
                    child: ClipOval(
                      child: Image(
                        image: pfp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Text(name),
                        ),
                        user != null
                            ? GoogleSignOutButton()
                            : GoogleSignInButton(),
                      ],
                    ),
                  ),
                ],
              ),
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