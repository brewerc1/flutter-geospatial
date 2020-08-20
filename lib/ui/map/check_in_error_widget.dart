import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/ui/map/check_in_view_type.dart';
import 'package:jacobspears/utils/callbacks.dart';

class CheckInErrorWidget extends StatelessWidget {

  final message;
  final VoidCallback onTryAgainButtonPress;
  final CheckedInStateCallBack onCloseButtonPress;

  const CheckInErrorWidget({Key key, this.message, this.onCloseButtonPress, this.onTryAgainButtonPress})
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
                child: Icon(Icons.error_outline, color: Colors.white, size: 50.0,),
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(10, 25.0, 10, 10),
              child: new Center(
                child: new Text(
                  message,
                  style: new TextStyle(
                      color: Colors.white
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
                        Icon(Icons.close, color: Colors.white,),
                        Text( "CLOSE",
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onTryAgainButtonPress,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text(
                          "TRY AGAIN",
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
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