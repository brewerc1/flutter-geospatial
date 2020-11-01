import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/utils/date_utils.dart';
import 'package:jacobspears/utils/sprintf.dart';
import 'package:jacobspears/values/strings.dart';

class SingleAlertView extends StatefulWidget {
  final Alert alert;

  SingleAlertView({
    Key key,
    @required this.alert,
  }) : super(key: key);

  @override
  _SingleAlertViewState createState() => _SingleAlertViewState(
        alert,
      );
}

class _SingleAlertViewState extends State<SingleAlertView> {
  final Alert _alert;

  _SingleAlertViewState(this._alert);

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return _buildScreen(_alert);
  }

  Widget _buildScreen(Alert alert) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    alert.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.warning,
                    color: _alert?.isActive == true ? Colors.red : Colors.grey,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        sprintf(Strings.reportedOn, [dateStringFromEpochMillis(_alert.timeStamp)]),
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      )),
                ]),
                Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      alert.geometry.printCoordinates(),
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )),
              ],
            ),
          ),
          _buildButtonColumn(
              _alert.iconName != null && _alert.iconName.isNotEmpty
                  ? getIconUsingPrefix(name: _alert.iconName)
                  : Icons.warning,
              alert.isActive),
        ],
      ),
    );

    Widget mapSection = Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        borderOnForeground: true,
        child: Container(
            height: 200,
            child: GoogleMap(
              onTap: (LatLng) {
                Navigator.pop(context);
              },
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  alert.geometry.coordinates[1],
                  alert.geometry.coordinates[0],
                ),
                zoom: 12.0,
              ),
              markers: {
                Marker(
                  // This marker id can be anything that uniquely identifies each marker.
                  markerId: MarkerId(alert.uuid),
                  position: LatLng(alert.geometry.coordinates[1],
                      alert.geometry.coordinates[0]),
                  infoWindow: InfoWindow(title: alert.title),
                  icon: BitmapDescriptor.defaultMarker,
                )
              },
              mapType: MapType.normal,
            )));

    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Html(
        data: alert.description,
      ),
    );

    var body = ListView(
      children: [
        titleSection,
        mapSection,
        textSection,
      ],
    );

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              icon: new Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
          leading: new Container(),
        ),
        body: Stack(
          children: <Widget>[
            body,
          ],
        ));
  }

  Column _buildButtonColumn(IconData icon, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            Strings.statusLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isActive ? Colors.red : Colors.grey,
            ),
          ),
        ),
        Icon(icon, color: isActive ? Colors.red : Colors.grey),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            (isActive ? Strings.active : Strings.inactive).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isActive ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
