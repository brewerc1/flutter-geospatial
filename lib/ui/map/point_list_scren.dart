import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/ui/map/PointsListViewModel.dart';
import 'package:provider/provider.dart';


class PointListScreen extends StatefulWidget {
  @override
  _PointListScreenState createState() => _PointListScreenState();
}

enum ViewType { LIST, MAP }

class _PointListScreenState extends State<PointListScreen> {
  PointListViewModel _viewModel;

  ViewType _currentTab = ViewType.LIST;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = PointListViewModel.fromContext(context);
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: CupertinoSegmentedControl<ViewType>(
                    groupValue: _currentTab,
                    children: {
                      ViewType.LIST: Text(
                        "List view",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _currentTab == ViewType.LIST ? Colors.white : Colors.blue,
                        ),
                      ),
                      ViewType.MAP: Text(
                        "Map View",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _currentTab == ViewType.MAP ? Colors.white : Colors.blue,
                        ),
                      )
                    },
                    onValueChanged: (value) {
                      setState(() {
                        _currentTab = value;
                      });
                    }),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-1, 0),
                  ),
                ],
              ),
              child: StreamBuilder<List<Point>>(
                stream: _viewModel.getPoints(),
                builder: (final BuildContext context, final AsyncSnapshot<List<Point>> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    List<Point> points = snapshot.data;
                    return ListView.builder(
                        itemCount: points.length,
                        itemBuilder: (context, i) {
                          return Column(children: [
                            _buildRow(context, points[i]),
                            Divider(),
                          ]);
                        });
                  } else {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 16.0),
                        Text(
                          "No point available at this time",
                          style: Theme.of(context).textTheme.headline2,
                        )
                      ],
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

  Widget _buildRow(final BuildContext context, final Point point) {
    return ListTile(
        dense: true,
        title: Text(
          point.name,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        subtitle: Text(
          point.uuid,
          style: TextStyle(fontSize: 14.0),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
        });
  }
}