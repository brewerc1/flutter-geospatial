import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final IconData icon;
  final String message;
  final String leftButtonName;
  final IconData leftIconData;
  final VoidCallback onLeftButtonPress;
  final String rightButtonName;
  final IconData rightIconData;
  final VoidCallback onRightLeftButtonPress;

  const DialogWidget({
      Key key,
      this.icon,
      this.message,
      this.leftButtonName,
      this.leftIconData,
      this.onLeftButtonPress,
      this.rightButtonName,
      this.rightIconData,
      this.onRightLeftButtonPress})
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
            color: Colors.blue, borderRadius: new BorderRadius.circular(10.0)),
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
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(10, 25.0, 10, 10),
              child: new Center(
                child: new Text(
                  message,
                  style: new TextStyle(color: Colors.white),
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (leftButtonName != null)
                    _buildButton(leftButtonName, leftIconData, onLeftButtonPress),
                  if (rightButtonName != null)
                    _buildButton(rightButtonName, rightIconData, onRightLeftButtonPress)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _buildButton(String message, IconData iconData, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.white,
          ),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
