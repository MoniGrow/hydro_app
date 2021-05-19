import 'package:flutter/material.dart';

import 'package:hydro_app/plant_monitor/monitor.dart';
import 'package:hydro_app/profile_settings/profile_main.dart';
import 'package:hydro_app/shop/shop_main.dart';
import 'package:hydro_app/utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Monitor(),
    ShopMain(),
    ProfileMain(),
  ];

  Widget _getWidgetAppBar(BuildContext context, int index) {
    return [
      null,
      null,
      null
    ][index];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double topHeight = MediaQuery.of(context).padding.top;
    // bottom nav bar is probably same height
    double barHeight = AppBar().preferredSize.height;
    Color activeIconColor = Colors.green;
    Widget appBar = _getWidgetAppBar(context, _selectedIndex);
    double bodyHeight = height - topHeight - barHeight;
    bodyHeight = appBar == null ? bodyHeight : bodyHeight - barHeight;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        // still use safe area in case of no app bar
        child: Container(
          height: bodyHeight,
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Images.icon_plant,
              color: Colors.grey[700],
              width: 24,  // default icon size i think?
            ),
            activeIcon: Image.asset(
              Images.icon_plant,
              color: activeIconColor,
              width: 24,  // default icon size i think?
            ),
            label: "Plants",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            label: "Profile",
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: activeIconColor,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
