import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AlertsScreen extends StatelessWidget {

  // final List<CustomAlertListItemFull> items;

  // AlertsScreen({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10.0),
      children: <Widget>[
        CustomAlertListItemFull(
          alertType: "one",
          title: 'Today, 10:00 am EST',
          subtitle:
          'Description, description, description, description, description, description'
              'description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
        CustomAlertListItemFull(
          alertType: "two",
          title: "06/18/20202, 10:00 pm",
          subtitle: 'Description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
        CustomAlertListItemFull(
          alertType: "three",
          title: "06/13/20202, 2:30 pm",
          subtitle:
          'Description, description, description, description, description, description'
              'description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
        CustomAlertListItemFull(
          alertType: "four",
          title: "06/10/20202, 11:30 am",
          subtitle:
          'Description, description, description, description, description, description'
              'description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
        CustomAlertListItemFull(
          alertType: "five",
          title: "06/08/20202, 6:45 pm",
          subtitle:
          'Description, description, description, description, description, description'
              'description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
        CustomAlertListItemFull(
          alertType: "one",
          title: "06/05/20202, 4:30 pm",
          subtitle:
          'Description, description, description, description, description, description'
              'description, description, description, description',
          location: '39.0866905, -84.5060716',
        ),
      ],
    );
  }
}

class _AlertDescription extends StatelessWidget {
  _AlertDescription({
    Key key,
    this.title,
    this.subtitle,
    this.location,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(
                    '$location',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CustomAlertListItemFull extends StatelessWidget {
  CustomAlertListItemFull({
    Key key,
    this.alertType,
    this.title,
    this.subtitle,
    this.location,
  }) : super(key: key);

  final String alertType;
  final String title;
  final String subtitle;
  final String location;
  
  IconData _getIconData(String type) {
    switch(type) {
      case "one": {
        return IconData(int.parse("0xf2dc"),
            fontFamily:'Material Design Icons',
            fontPackage:'material_design_icons_flutter');
      }
      case "two": {
        return Icons.cloud;
      }
      case "three": {
        return Icons.flash_on;
      }
      case "four": {
        return Icons.pool;
      }
      default: {
        return Icons.delete;
      }
    }
  }

  Color _getIconColor(String type) {
    switch(type) {
      case "one": {
        return Colors.green;
      }
      case "two": {
        return Colors.blueAccent;
      }
      case "three": {
        return Colors.red;
      }
      case "four": {
        return Colors.deepPurple;
      }
      default: {
        return Colors.orangeAccent;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget thumbnailImage = new Container(
      height: 50,
      width: 50,
      child:
      Icon(
        _getIconData(alertType),
        color: Colors.white,
        size: 30,
      ),
      decoration: BoxDecoration(
        color: _getIconColor(alertType),
        shape: BoxShape.circle
      ),
    );

    Widget iconView = Stack(
      children: <Widget>[
        Center(
            child: Container(
              width: 2,
              height: double.maxFinite,
              color: Colors.black,
            )
        ),
        Center(
          child: thumbnailImage,
        )
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             AspectRatio(
                aspectRatio: 0.5,
                child: iconView,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 2.0, 10.0),
                child: _AlertDescription(
                  title: title,
                  subtitle: subtitle,
                  location: location,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ...