import 'package:flutter/material.dart';

class ReportDropDownWidget extends StatefulWidget {
  ReportDropDownWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ReportDropdownWidget();
}

class _ReportDropdownWidget extends State<ReportDropDownWidget> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
