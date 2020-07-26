import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';

class PointOfInterestScreen extends StatefulWidget {
  final Point point;

  PointOfInterestScreen({
    Key key,
    @required this.point,
  }) : super(key: key);

  @override
  _PointOfInterestScreenState createState() => _PointOfInterestScreenState(point);
}

class _PointOfInterestScreenState extends State<PointOfInterestScreen> {
  final Point point;

  _PointOfInterestScreenState(this.point);

  PointListViewModel _viewModel;
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Checking in?"),
          content: Text("Are you ready to check into ${point.name}?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Check in"),
              onPressed: () {
                // TODO add error cases and check location
                _viewModel.checkIn(point.uuid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                    point.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  point.geometry.printCoordinates(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _showDialog();
                },
              child: _buildButtonColumn(Colors.blue, Icons.add_location, "Check in")
              ),
            ],
          ),
        ],
      ),
    );

    Widget mapSection = Card(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        borderOnForeground: true,
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: 200,
                child: GoogleMap(
                  onTap: (LatLng) {
                    Navigator.pop(context);
                  },
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      point.geometry.coordinates[1],
                      point.geometry.coordinates[0],
                    ),
                    zoom: 12.0,
                  ),
                  markers: {
            Marker(
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(point.name),
              position: LatLng(
                  point.geometry.coordinates[1], point.geometry.coordinates[0]),
              infoWindow:
              InfoWindow(title: point.name),
              icon: BitmapDescriptor.defaultMarker,
            )
          },
                  mapType: MapType.normal,
                )
            )));

    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Html(
        data: point.description,
      ),
    );

    return Scaffold(
        appBar: AppBar(
        actions: <Widget>[
          new IconButton(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ],
        leading: new Container(),
      ),
      body: ListView(
          children: [
            titleSection,
            mapSection,
            textSection,
          ],
    ));
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
