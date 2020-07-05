import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jacobspears/ui/reports/CameraScreen.dart';
import 'package:jacobspears/ui/reports/dropdownWidget.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReportsScreen();
  }
}

class _ReportsScreen extends State<ReportsScreen> {

  bool showCamera = false;

  void _onCameraPressed() {
    setState(() {
      showCamera = !showCamera;
    });
  }

  void onSubmitPressed() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    Widget textSection = Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 6),
      child: Text(
        'Select type of incident to report',
        softWrap: true,
      ),
    );

    Widget dropDownSection = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: ReportDropDownWidget(),
    );

    Widget descriptionText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
      child: Text(
        'Enter a description of the incident',
        softWrap: true,
      ),
    );

    Widget descriptionEditText = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter description'
          ),
          maxLines: 5,
          keyboardType: TextInputType.multiline
      ),
    );

    Widget addPhotoButton = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: FlatButton.icon(
        color: Colors.blue,
        icon: Icon(Icons.add_a_photo),
        label: Text('Add a Photo'),
        textColor: Colors.white,
        onPressed: () {
          _onCameraPressed();
        },
      ),
    );

    Widget addPhotoContainer = Container(
      child: Stack (
        children: <Widget>[
          Image.asset(
            'images/licking_river_image.jpg',
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: addPhotoButton
          )
        ],
      )
    );

    Widget submitButton = Container(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
        child: FlatButton.icon(
          color: Colors.blue,
          onPressed: () {
            // to do
          },
          icon: Icon(Icons.add_alert),
          label: Text('Submit report'),
          textColor: Colors.white,
        )
    );

    Widget listView = ListView(
      children: <Widget>[
      addPhotoContainer,
      textSection,
      dropDownSection,
      descriptionText,
      descriptionEditText
      ]
    );


    return showCamera ? CameraExampleHome() : Container(
      child: Stack(
        children: <Widget>[
          listView,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: submitButton,
          )
        ],
      ),
    );
  }

}