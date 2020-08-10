import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:intl/intl.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/check_in_result.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/app/model/user.dart';
import 'package:jacobspears/ui/account/user_settings_viewmodel.dart';
import 'package:jacobspears/ui/components/error_screen.dart';
import 'package:jacobspears/ui/components/loading_screen.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingScreen> {
  UserSettingsViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = UserSettingsViewModel.fromContext(context);
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => _viewModel,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              child: StreamBuilder<Response<List<CheckInResult>>>(
                stream: _viewModel.getHistory(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<List<CheckInResult>>> snapshot) {
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
                        if (snapshot.data.data.isNotEmpty) {
                          List<CheckInResult> checkIns = snapshot.data.data;
                          return _buildUi(
                              context,
                              checkIns,
                              User(
                                firstName: "Sierra",
                                lastName: "OBryan",
                                email: "sierrarobryan@gmail.com"
                              )
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

  Widget _buildUi(BuildContext context, List<CheckInResult> checkIns, User user) {
    Widget infoSection = Container(
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
                    user.firstName + " " + user.lastName,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                ])
              ],
            ),
          ),
        ],
      ),
    );

    Widget badgeSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBadgeColumn("TOTAL", "CHECK INS", _totalCheckins(checkIns).toString(), true),
          _buildBadgeColumn("TOTAL", "POINTS", _totalPointVisited(checkIns).toString(), true),
          _buildBadgeColumn("LAST", "CHECKIN", _lastCheckIn(checkIns), false),
        ],
      ),
    );

    Widget historyText = Container(
      margin: const EdgeInsets.fromLTRB(32, 32, 32, 0),
        child: Text(
      "YOUR HISTORY",
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    ));

    Widget historyList = ListView.builder(
        shrinkWrap: true,
        itemCount: checkIns.length,
        itemBuilder: (context, i) {
          return Column(children: [
            _buildPoint(context, checkIns[i])
          ]);
        });;

    return ListView(
      children: <Widget>[
        infoSection,
        badgeSection,
        historyText,
        historyList
      ],
    );

  }

  Widget _buildPoint(final BuildContext context, final CheckInResult checkIn) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, checkIn.point),
          ListView.builder(
              itemCount: checkIn.checkInTimestamps.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return Column(
                    children: [_buildRow(context, checkIn.checkInTimestamps[i])]);
              })
        ]);
  }

  Widget _buildHeader(final BuildContext context, final Point point) {
    Widget left = Align(
      alignment: Alignment.topCenter,
      child: InkWell(
          onTap: () { },
          child: new Container(
            height: 50,
            width: 50,
            child: Icon(
              (point.iconName != null && point.iconName.isNotEmpty)
                  ? getIconUsingPrefix(name: point.iconName)
                  : Icons.location_on,
              color: Colors.white,
            ),
            decoration:
            BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          )),
    );

    Widget middle = Expanded(
        child: InkWell(
            onTap: () { },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
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
                        ],
                      )),
                ],
              ),
            )));

    Widget right = InkWell(
        onTap: () {
        },
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[Icon(Icons.chevron_right)])));

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 5),
      child: new Row(
        children: <Widget>[
          left,
          middle,
          // right,
        ],
      ),
    );
  }

  Widget _buildRow(final BuildContext context, final double timestamp) {
    return Container(
        margin: const EdgeInsets.fromLTRB(90, 0, 20, 0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              color: Colors.green,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()).toString()
            ))
        ],
    ));
  }

  Column _buildBadgeColumn(String top, String bottom, String value, bool showIcon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            top,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Icon(
              Icons.star,
              color: showIcon ? Colors.blue : Colors.grey[300],
              size: 48.0,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: showIcon ? Colors.white : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        Container(
          child: Text(
            bottom,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  int _totalCheckins(List<CheckInResult> checkIns) {
    return checkIns.map((e) => e.checkInTimestamps)
        .expand((element) => element)
        .toList().length;
  }

  int _totalPointVisited(List<CheckInResult> checkIns) {
    return checkIns.length;
  }

  String _lastCheckIn(List<CheckInResult> checkIns) {
    var format = new DateFormat("yMd");
    var dates = checkIns.map((e) => e.checkInTimestamps)
        .expand((element) => element)
        .toList();
    dates.sort();
    return format.format(DateTime.fromMillisecondsSinceEpoch(dates.last.toInt()));
  }
}
