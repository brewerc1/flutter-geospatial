import 'package:flutter/material.dart';
import 'package:jacobspears/ui/alerts/alerts_screen.dart';
import 'package:jacobspears/ui/map/points_list_screen.dart';

import 'account/settings_screen.dart';
import 'reports/reports.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_currentIndex == 0) {
      body = PointListScreen();
    } else if (_currentIndex == 1) {
      body = AlertsScreen();
    } else if (_currentIndex == 2) {
      body = ReportsScreen();
    } else {
      body = SettingScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Jacob Spears Trail'),
      ),
      body: body,
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
