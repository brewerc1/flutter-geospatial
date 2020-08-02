import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/app/model/cluster.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/segment.dart';
import 'package:jacobspears/ui/components/colored_tab_bar.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';
import 'package:jacobspears/ui/map/error_screen.dart';
import 'package:jacobspears/ui/map/loading_screen.dart';
import 'package:jacobspears/ui/map/map_widget.dart';
import 'package:jacobspears/ui/map/point_of_interest_screen.dart';
import 'package:provider/provider.dart';

class PointListScreen extends StatefulWidget {
  @override
  PointListScreenState createState() => PointListScreenState();
}

class PointListScreenState extends State<PointListScreen> with SingleTickerProviderStateMixin {
  PointListViewModel _viewModel;
  TabController _controller;
  StreamSubscription _tabSubscription;

  void _navigateToSingle(Point point) {
    _viewModel.getPointById(point);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => buildSinglePoint(context)));
  }

  void switchToMap(Point point) {
    _viewModel.setSelectedPoint(point);
    _controller.animateTo(1);
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = PointListViewModel.fromContext(context);
    _viewModel.init();
    _tabSubscription = _viewModel.tabEvent.listen((event) => _controller.animateTo(event == CurrentTab.MAP ? 1 : 0));

  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: ColoredTabBar(
              Colors.blue,
              TabBar(
                controller: _controller,
                  indicatorColor: Colors.white, tabs: [
                Tab(text: "LIST",),
                Tab(text: "MAP",)
              ])),
          body: TabBarView(
              controller: _controller,
              children: [
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
              child: StreamBuilder<Response<Cluster>>(
                stream: _viewModel.pointsWithCheckInStream(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<Cluster>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      message: snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingScreen(
                          message: "Loading...",
                        );
                        break;
                      case Status.COMPLETED:
                        if (snapshot.data.data.segmants.isNotEmpty) {
                          List<Point> points = snapshot.data.data.segmants
                              .map((e) => e.points)
                              .expand((element) => element)
                              .toList();
                          return MapWidget(
                            viewModel: _viewModel,
                            items: points,
                            onNavigateCallback: _navigateToSingle,
                          );
                        } else {
                          return ErrorScreen(
                            message: "Oops, something went wrong",
                          );
                        }
                        break;
                      default:
                        return ErrorScreen(
                          message: snapshot.error.toString(),
                        );
                        break;
                    }
                  } else {
                    return ErrorScreen(
                      message: "Oops, something went wrong",
                    );
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
              child: StreamBuilder<Response<Cluster>>(
                stream: _viewModel.pointsWithCheckInStream(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<Cluster>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      message: snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingScreen(
                          message: "Loading...",
                        );
                        break;
                      case Status.COMPLETED:
                        if (snapshot.data.data.segmants.isNotEmpty) {
                          List<Segment> segments = snapshot.data.data.segmants;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: segments.length,
                              itemBuilder: (context, i) {
                                return Column(children: [
                                  _buildSegment(context, segments[i])
                                ]);
                              });
                        } else {
                          return ErrorScreen(
                            message: "Oops, something went wrong",
                          );
                        }
                        break;
                      default:
                        return ErrorScreen(
                          message: snapshot.error.toString(),
                        );
                        break;
                    }
                  } else {
                    return ErrorScreen(
                      message: "Oops, something went wrong",
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(final BuildContext context, final Segment segment) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, segment),
          ListView.builder(
              itemCount: 2,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Column(
                    children: [_buildRow(context, segment.points[i])]);
              })
        ]);
  }

  Widget _buildHeader(final BuildContext context, final Segment segment) {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                segment.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              segment.description,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(final BuildContext context, final Point point) {
    Widget infoBlock = InkWell(
      onTap: () {
        _navigateToSingle(point);
      },
      child: Expanded(
          child: Row(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                      Text(
                        point.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.location_on),
                                  Text(
                                    point.geometry.printCoordinates(),
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              if (point.checkedIn)
                                Row(children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    "Checked In",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  )
                                ]),
                            ],
                          )),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.chevron_right)
            ),
          ])));

      Widget iconView = Align(
      alignment: Alignment.topCenter,
      child: InkWell(
          onTap: () {
            switchToMap(point);
          },
          child: new Container(
            height: 50,
            width: 50,
            child: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            decoration:
            BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          )),
    );

    return Container (
      margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.5,
              child: iconView,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: infoBlock,
            ),
          ],
        ),
      ),
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
              child: StreamBuilder<Response<Point>>(
                stream: _viewModel.getPointOfInterest(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<Point>> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScreen(
                      message: snapshot.error.toString(),
                    );
                  } else if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        return LoadingScreen(
                          message: "Loading...",
                        );
                        break;
                      case Status.COMPLETED:
                        if (snapshot.data.data != null) {
                          Point point = snapshot.data.data;
                          return PointOfInterestScreen(point: point, viewModel: _viewModel,);
                        } else {
                          return ErrorScreen(
                            message: "Oops, something went wrong",
                          );
                        }
                        break;
                      default:
                        return ErrorScreen(
                          message: snapshot.error.toString(),
                        );
                        break;
                    }
                  } else {
                    return ErrorScreen(
                      message: "Oops, something went wrong",
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
