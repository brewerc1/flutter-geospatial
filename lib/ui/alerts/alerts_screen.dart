import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'package:jacobspears/app/model/alert.dart';
import 'package:jacobspears/app/model/response.dart';
import 'package:jacobspears/ui/alerts/alert_viewmodel.dart';
import 'package:jacobspears/ui/alerts/single_alert_view.dart';
import 'package:jacobspears/ui/components/error_screen.dart';
import 'package:jacobspears/ui/components/loading_screen.dart';
import 'package:jacobspears/utils/date_utils.dart';
import 'package:provider/provider.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {

  AlertViewModel _viewModel;

  void _navigateToAlert(Alert alert) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleAlertView(alert: alert,)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel = AlertViewModel.fromContext(context);
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
              child: StreamBuilder<Response<List<Alert>>>(
                stream: _viewModel.getAlerts(),
                builder: (final BuildContext context,
                    final AsyncSnapshot<Response<List<Alert>>> snapshot) {
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
                          List<Alert> alerts = snapshot.data.data;
                          return ListView.builder(
                              itemCount: alerts.length,
                              itemBuilder: (context, i) {
                                return Column(children: [
                                  _buildAlertRow(context, alerts[i])
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

  Widget _buildAlertRow(BuildContext context, Alert alert) {
    Widget thumbnailImage = new Container(
      height: 50,
      width: 50,
      child:
      Icon(
        alert.iconName != null && alert.iconName.isNotEmpty ? getIconUsingPrefix(name: alert.iconName) : Icons.warning,
        color: Colors.white,
        size: 30,
      ),
      decoration: BoxDecoration(
          color: alert.isActive ? Colors.blue : Colors.grey,
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

    Widget description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                printDate(alert.timeStamp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5.0)),
              Text(
                alert.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.0,
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
                    alert.geometry.printCoordinates(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5.0)),
            ],
          ),
        ),
      ],
    );

    Widget right = InkWell(
        onTap: () {
          _navigateToAlert(alert);
        },
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[Icon(Icons.chevron_right)])));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: 110,
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
                child: description
              ),
            ),
            right
          ],
        ),
      ),
    );
  }

}