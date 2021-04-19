import 'package:flutter/material.dart';

import 'package:hydro_app/utils.dart';

/// Soon to be replaced by shopping screen
class PetScreenMain extends StatefulWidget {
  @override
  _PetScreenMainState createState() => _PetScreenMainState();
}

class _PetScreenMainState extends State<PetScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40, bottom: 20),
          child: Row(
            children: [
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: ElevatedButton(
                  child: Text("Customization"),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
        // the actual pet screen, will be animated and stuff, not just
        // an image later probably
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 0.9,
            heightFactor: 0.8,
            child: Image(
              image: AssetImage(Images.qb),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
