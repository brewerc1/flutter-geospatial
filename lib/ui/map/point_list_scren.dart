import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/ui/components/colored_tab_bar.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';
import 'package:jacobspears/ui/map/error_screen.dart';
import 'package:jacobspears/ui/map/map_widget.dart';
import 'package:jacobspears/ui/map/point_of_interest_screen.dart';
import 'package:provider/provider.dart';

class PointListScreen extends StatefulWidget {
  @override
  _PointListScreenState createState() => _PointListScreenState();
}

enum ViewType { LIST, MAP }

class _PointListScreenState extends State<PointListScreen> {
  PointListViewModel _viewModel;

  void _navigateToSingle(String uuid) {
    _viewModel.getPointById(uuid);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => buildSinglePoint(context)));
    buildSinglePoint(context);
  }

  void _checkIn(Point point) {
    _viewModel.checkIn(point.uuid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = PointListViewModel.fromContext(context);
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: ColoredTabBar(
              Colors.blue,
              TabBar(indicatorColor: Colors.white, tabs: [
                Tab(text: "LIST",),
                Tab(text: "MAP",)
              ])),
          body: TabBarView(children: [
            new Container(child: _buildList(context)),
            new Container(child: _buildMap(context),
            )
          ]),
        ));
  }

  Widget _buildMap(BuildContext context) {
    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<List<Point>>(
                stream: _viewModel.getPoints(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<List<Point>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(message: snapshot.error.toString(),);
                  } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    List<Point> points = snapshot.data;
                    return MapWidget(
                      items: points,
                      onNavigateCallback: _navigateToSingle,
                      checkInCallback: _checkIn,
                    );
                  } else {
                    return ErrorScreen(message: "Oops, something went wrong",);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<List<Point>>(
                stream: _viewModel.getPoints(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<List<Point>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(message: snapshot.error.toString(),);
                  } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    List<Point> points = snapshot.data;
                    return ListView.builder(
                        itemCount: points.length,
                        itemBuilder: (context, i) {
                          return Column(
                              children: [_buildRow(context, points[i])]);
                        });
                  } else {
                    return ErrorScreen(message: "Oops, something went wrong",);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(final BuildContext context, final Point point) {
//    Widget infoBlock = Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Expanded(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                point.name,
//                maxLines: 2,
//                overflow: TextOverflow.ellipsis,
//                style: const TextStyle(
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//              const Padding(padding: EdgeInsets.only(top: 20.0)),
//            ],
//          ),
//        ),
//        Expanded(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Icon(Icons.location_on),
//                  Text(
//                    point.geometry.printCoordinates(),
//                    style: const TextStyle(
//                      fontSize: 12.0,
//                      color: Colors.black54,
//                    ),
//                  ),
//                const Padding(padding: EdgeInsets.only(bottom: 20.0)),
//                ],
//              )
//            ],
//          ),
//        ),
//      ],
//    );
//
//    Widget thumbnailImage = new Container(
//      height: 50,
//      width: 50,
//      child:
//      Icon(
//        Icons.location_on,
//        color: Colors.white,
//      ),
//      decoration: BoxDecoration(
//          color: Colors.blue,
//          shape: BoxShape.circle
//      ),
//    );
//
//    Widget iconView = Stack(
//      children: <Widget>[
//        Center(
//            child: Container(
//              width: 2,
//              height: double.maxFinite,
//              color: Colors.black,
//            )
//        ),
//        Center(
//          child: thumbnailImage,
//        )
//      ],
//    );
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 1.0),
//      child: SizedBox(
//        height: 100,
//        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            AspectRatio(
//              aspectRatio: 0.5,
//              child: iconView,
//            ),
//            Expanded(
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 2.0, 10.0),
//                child: infoBlock,
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
    return Card(
        child: ListTile(
            leading: Icon(
              Icons.location_on,
              size: 36.0,
            ),
            title: Text(
              point.name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            subtitle: Text(
              point.geometry.printCoordinates(),
              style: TextStyle(fontSize: 14.0),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () { _navigateToSingle(point.uuid); }
            )
    );
  }

  Widget buildSinglePoint(BuildContext context) {
    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<Point>(
                stream: _viewModel.getPointOfInterest(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Point> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(message: snapshot.error.toString(),);
                  } else if (snapshot.hasData) {
                    Point point = snapshot.data;
                    return PointOfInterestScreen(point: point,);
                  } else {
                    return ErrorScreen(message: "Oops, something went wrong",);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

//  Widget buildErrorState(BuildContext context) {
//    return
//  }
}
