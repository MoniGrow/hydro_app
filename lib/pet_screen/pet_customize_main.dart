import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

class PetCustomizeMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 10,
              bottom: 30,
              child: Column(
                children: [
                  Text("Customize pet"),
                  IconButton(
                    icon: Image.asset(Images.cat),
                    iconSize: 180,
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 30,
              child: Column(
                children: [
                  Text("Edit behaviour"),
                  IconButton(
                    icon: Image.asset(Images.brain),
                    iconSize: 160,
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 150,
              child: Column(
                children: [
                  Text("Edit background"),
                  IconButton(
                    icon: Image.asset(Images.tree),
                    iconSize: 160,
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: IconButton(
                icon: Image.asset(Images.shopfront),
                iconSize: 100,
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
