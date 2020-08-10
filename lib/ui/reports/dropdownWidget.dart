import 'package:flutter/material.dart';

class ReportDropDownWidget extends StatefulWidget {
  final List<String> items;
  ReportDropDownWidget({Key key, this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ReportDropdownWidget(items);
}

class _ReportDropdownWidget extends State<ReportDropDownWidget> {
  List<String> items;
  String dropdownValue = "";

  _ReportDropdownWidget(this.items);

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
      items: items
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
