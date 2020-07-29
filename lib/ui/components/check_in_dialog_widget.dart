import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/utils/Callback.dart';

class CheckInDialogWidget extends StatelessWidget {
  final String name; 
  final VoidCallback onCheckInButton;
  final CheckedInStateCallBack onCloseButtonPress;

  const CheckInDialogWidget({Key key, this.name, this.onCloseButtonPress, this.onCheckInButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
      ),
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.white,
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
                child: Icon(Icons.not_listed_location, color: Colors.blue, size: 50.0,),
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(10, 25.0, 10, 10),
              child: new Center(
                child: new Text(
                  "Are you ready to check into $name?",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Colors.blue,
                  ),
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      onCloseButtonPress(CheckInViewType.BODY);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.close, color: Colors.blue,),
                        Text( "CLOSE",
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onCheckInButton,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: Colors.blue,
                        ),
                        Text(
                          "CHECK IN",
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}