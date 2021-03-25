import 'package:flutter/material.dart';

class HydroOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Image overhead = Image(
      image: AssetImage("graphics/overhead_view_basic.png"),
      fit: BoxFit.contain,
    );
    return Container(
      child: overhead,
    );
  }
}
