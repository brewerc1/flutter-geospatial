import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jacobspears/app/model/point_of_interest.dart';

class ListWidget extends StatelessWidget {
  final List<PointOfInterest> items;
  final VoidCallback onPressedCallback;

  ListWidget({Key key, @required this.items, this.onPressedCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.description),
          );
        },
      ),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.topRight,
              child: Column(children: <Widget>[
                FloatingActionButton(
                  onPressed: onPressedCallback,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.map, size: 36.0),
                ),
              ]))),
    ]);
  }
}
