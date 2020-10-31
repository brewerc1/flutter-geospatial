import 'package:flutter/material.dart';
import 'package:jacobspears/app/app_providers.dart';
import 'package:jacobspears/ui/home.dart';
import 'package:jacobspears/values/org_variants.dart';
import 'package:jacobspears/values/variants.dart';

void main() {
  runApp(AppProviders(
    orgVariant: OrgVariant.nku(),
    variant: Variant.development(),
    child: MaterialApp(
      title: 'Jacob Spears Trail',
      home: Home(),
    ),
  ));
}