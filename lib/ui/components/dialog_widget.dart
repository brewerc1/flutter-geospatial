import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/values/strings.dart';

enum ButtonType { CLOSE, TRY_AGAIN, PERMISSION, CHECK_IN }

enum DialogType { PROGRESS, ICON }

class DialogWidget extends StatelessWidget {
  final DialogType dialogType; // default ICON
  final bool invertColor; // default false
  final IconData icon; // will not be use if dialogType == Progress
  final String message;
  final ButtonType leftButtonType;
  final String leftButtonName; // will not be used if leftButtonType is set
  final IconData leftIconData; // will not be used if leftButtonType is set
  final VoidCallback onLeftButtonPress;
  final ButtonType rightButtonType;
  final String rightButtonName; // will not be used if rightButtonType is set
  final IconData rightIconData; // will not be used if rightButtonType is set
  final VoidCallback onRightLeftButtonPress;

  const DialogWidget(
      {Key key,
      this.dialogType,
      this.invertColor,
      this.icon,
      this.message,
      this.leftButtonType,
      this.leftButtonName,
      this.leftIconData,
      this.onLeftButtonPress,
      this.rightButtonType,
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
            color: (invertColor == true) ? Colors.white : Colors.blue,
            borderRadius: new BorderRadius.circular(10.0)),
        width: 300.0,
        height: 200.0,
        alignment: AlignmentDirectional.center,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: (dialogType == DialogType.PROGRESS)
                  ? CircularProgressIndicator(
                      value: null,
                      strokeWidth: 7.0,
                      backgroundColor:
                          (invertColor == true) ? Colors.blue : Colors.white,
                    )
                  : new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(
                        icon,
                        color:
                            (invertColor == true) ? Colors.blue : Colors.white,
                        size: 50.0,
                      ),
                    ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(10, 25.0, 10, 10),
              child: new Center(
                child: new Text(
                  message,
                  style: new TextStyle(
                    color: (invertColor == true) ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (leftButtonType != null)
                    _buildButtonFromType(leftButtonType, onLeftButtonPress)
                  else if (leftButtonName != null)
                    _buildButtonCustom(
                        leftButtonName, leftIconData, onLeftButtonPress),
                  if (rightButtonType != null)
                    _buildButtonFromType(
                        rightButtonType, onRightLeftButtonPress)
                  else if (rightButtonName != null)
                    _buildButtonCustom(
                        rightButtonName, rightIconData, onRightLeftButtonPress)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _buildButtonCustom(
      String message, IconData iconData, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            iconData,
            color: (invertColor == true) ? Colors.blue : Colors.white,
          ),
          Text(
            message.toUpperCase(),
            style: TextStyle(
              fontSize: 12.0,
              color: (invertColor == true) ? Colors.blue : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildButtonFromType(ButtonType buttonType, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            _buttonIcon(buttonType),
            color: (invertColor == true) ? Colors.blue : Colors.white,
          ),
          Text(
            _buttonMessage(buttonType).toUpperCase(),
            style: TextStyle(
              fontSize: 12.0,
              color: (invertColor == true) ? Colors.blue : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _buttonMessage(ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.CLOSE:
        return Strings.buttonClose;
      case ButtonType.TRY_AGAIN:
        return Strings.buttonTryAgain;
      case ButtonType.PERMISSION:
        return Strings.buttonTurnOn;
      case ButtonType.CHECK_IN:
        return Strings.checkIn;
      default:
        return null;
    }
  }

  IconData _buttonIcon(ButtonType buttonType) {
    switch (buttonType) {
      case ButtonType.CLOSE:
        return Icons.close;
      case ButtonType.TRY_AGAIN:
        return Icons.refresh;
      case ButtonType.PERMISSION:
        return Icons.check;
      case ButtonType.CHECK_IN:
        return Icons.check;
      default:
        return null;
    }
  }
}
