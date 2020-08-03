import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  ErrorScreen({
    Key key,
    @required this.message,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.map, color: Colors.grey[300], size: 84,),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Icon(Icons.signal_wifi_off, color: Colors.blue, size: 48,),
                )
              )
            ],

          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      )
    ));
  }

}