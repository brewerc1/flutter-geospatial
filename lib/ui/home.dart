import 'package:flutter/material.dart';
import 'package:jacobspears/ui/account/settings.dart';
import 'package:jacobspears/ui/alerts/alerts.dart';
import 'package:jacobspears/ui/map/point_list_screen.dart';

import 'reports/reports.dart';

import 'alerts/alerts.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    PointListScreen(),
    AlertsScreen(),
    ReportsScreen(),
    SettingsScreen(Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jacob Spears'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.warning),
            title: new Text('Alerts'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_alert),
              title: Text('Report')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
