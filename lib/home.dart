import 'package:flutter/material.dart';

import 'package:hydro_app/pet_screen/pet_screen_main.dart';
import 'package:hydro_app/plant_monitor/monitor.dart';
import 'package:hydro_app/profile_settings/profile_main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Monitor(),
    PetScreenMain(),
    ProfileMain(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.waves),
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
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
