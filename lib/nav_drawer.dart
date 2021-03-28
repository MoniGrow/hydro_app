import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          onTap: null,
        ),
        ListTile(
          title: Text("Pet screen"),
          onTap: null,
        ),
      ],
    );
  }
}
