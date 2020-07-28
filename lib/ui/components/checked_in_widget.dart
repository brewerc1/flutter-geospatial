import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/utils/Callback.dart';

class CheckedInWidget extends StatelessWidget {
  final String name;
  final CheckedInStateCallBack onButtonPress;

  const CheckedInWidget({Key key, this.name, this.onButtonPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
      ),
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.blue,
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
                  "Checked into $name",
                  style: new TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  onButtonPress(CheckInViewType.BODY);
                },
                child: Container (
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      "CLOSE",
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}