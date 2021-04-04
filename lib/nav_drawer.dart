import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class NavDrawer extends StatelessWidget {
  final String currentPath;

  NavDrawer(this.currentPath);

  @override
  Widget build(BuildContext context) {
    Function navigateTo = (path) {
      // pop drawer from stack
      Navigator.pop(context);
      if (currentPath != path) {
        Navigator.pushNamed(
          context,
          path,
        );
      }
    };
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text("Drawer Header"),
        ),
        ListTile(
          title: Text("Profile"),
          onTap: null,
        ),
        ListTile(
          title: Text("Plant monitor"),
          onTap: () => navigateTo(ScreenPaths.monitor),
        ),
        ListTile(
          title: Text("Pet screen"),
          onTap: () => navigateTo(ScreenPaths.pet),
        ),
      ],
    );
  }
}
