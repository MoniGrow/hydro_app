import 'package:flutter/material.dart';

import 'package:hydro_app/nav_bottom.dart';
import 'package:hydro_app/utils.dart';

class PetScreenMain extends StatefulWidget {
  @override
  _PetScreenMainState createState() => _PetScreenMainState();
}

class _PetScreenMainState extends State<PetScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [],
      ),
      bottomNavigationBar: NavBottom(ScreenPaths.pet),
    );
  }
}
