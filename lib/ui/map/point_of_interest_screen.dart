import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';

import 'dart:developer' as developer;

class PointOfInterestScreen extends StatefulWidget {
  final Point point;

  PointOfInterestScreen({
    Key key,
    @required this.point,
  }) : super(key: key);

  @override
  _PointOfInterestScreenState createState() => _PointOfInterestScreenState(point);
}

enum ViewType { BODY, CHECKING_IN, CHECKED_IN, ERROR }

class _PointOfInterestScreenState extends State<PointOfInterestScreen> {
  final Point point;

  _PointOfInterestScreenState(this.point);

  PointListViewModel _viewModel;
  GoogleMapController mapController;
  ViewType _viewType = ViewType.BODY;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future _setViewState(ViewType viewType) async {
      setState(() {
        _viewType = viewType;
      });
  }

  void _checkIn() {
    setState(() {
      _viewType = ViewType.CHECKING_IN;
      new Future.delayed(new Duration(seconds: 3), _login);
    });
  }


  Future _login() async{
    setState((){
      _viewType = ViewType.CHECKED_IN;
      new Future.delayed(new Duration(seconds: 3), _close);

    });
  }

  Future _close() async {
    setState(() {
      _viewType = ViewType.BODY;

    });
  }
//    final Response<String> result = await _viewModel.checkIn(point.uuid);
//    developer.log("$result");
//    switch (result.status) {
//      case Status.LOADING:
//        developer.log("loading!");
//        // _setViewState(ViewType.CHECKING_IN);
//        break;
//      case Status.COMPLETED:
//        developer.log("completed!");
//        // _setViewState(ViewType.CHECKED_IN);
//        break;
//      case Status.ERROR:
//        developer.log("error!");
//        // _setViewState(ViewType.ERROR);
//        break;
//    }
//  }

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
                Navigator.of(context).pop();
                _checkIn();
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
    _viewModel = PointListViewModel.fromContext(context);
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
                      //_checkIn();
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
            ));

    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Html(
        data: point.description,
      ),
    );

    var body = ListView(
      children: [
        titleSection,
        mapSection,
        textSection,
      ],
    );

    Widget bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Checking into ${point.name}",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget bodyDone = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(Icons.check, color: Colors.white, size: 50.0,),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "Checked into ${point.name}",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        body:  _viewType == ViewType.BODY ? body : (_viewType == ViewType.CHECKED_IN ? bodyDone : bodyProgress)
    );
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
