import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point_of_interest.dart';
import 'package:jacobspears/ui/account/settings.dart';
import 'package:jacobspears/ui/alerts/alerts.dart';
import 'package:jacobspears/ui/map/map.dart';
import 'package:jacobspears/ui/reports/reports.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    MapScreen(
      items: [
        PointOfInterest(const LatLng(39.0866905, -84.5060716), "Point A",
            "Description of Point A"),
        PointOfInterest(const LatLng(39.0236095, -84.5011132), "Point B",
            "Description of Point B"),
        PointOfInterest(const LatLng(39.0168334, -84.4744538), "Point C",
            "Description of Point C")
      ]
    ),
    AlertsScreen(items: List<ListItem>.generate(
      30,
          (i) => i % 6 == 0
          ? HeadingItem("5/$i/2020")
          : MessageItem("Alert $i", "Alert body $i"),
      ),
    ),
    ReportScreen(Colors.green),
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
