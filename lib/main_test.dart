import 'package:flutter/material.dart';
import 'package:jacobspears/app/app_providers.dart';
import 'package:jacobspears/ui/home.dart';
import 'package:jacobspears/values/variants.dart';

void main() {
  runApp(AppProviders(
    variant: Variant.test(),
    child: MaterialApp(
      title: 'Jacob Spears',
      home: Home(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jacob Spears',
      home: Home(),
    );
  }
}