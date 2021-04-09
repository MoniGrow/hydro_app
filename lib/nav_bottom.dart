import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class NavBottom extends StatelessWidget {
  final String currentPath;

  NavBottom(this.currentPath);

  void navigateTo(BuildContext context, String path) {
    if (currentPath != path) {
      Navigator.popAndPushNamed(
        context,
        path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          // plant monitor
          Expanded(
            child: IconButton(
              icon: Icon(Icons.waves),
              onPressed: () => navigateTo(context, ScreenPaths.monitor),
            ),
          ),
          // pet screen
          Expanded(
            child: IconButton(
              icon: Icon(Icons.child_care),
              onPressed: () => navigateTo(context, ScreenPaths.pet),
            ),
          ),
          // profile probably
          Expanded(
            child: IconButton(
              icon: Icon(Icons.assignment_ind),
              onPressed: () => navigateTo(context, ScreenPaths.profile),
            ),
          ),
        ],
      ),
    );
  }
}