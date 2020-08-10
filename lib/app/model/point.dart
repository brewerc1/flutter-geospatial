import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jacobspears/app/model/geometry.dart';
import 'package:jacobspears/app/model/segment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

@immutable
@JsonSerializable()
class Point extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "geometry")
  final Geometry geometry;

  @JsonKey(name: "segments")
  final List<String> segments;

  @JsonKey(name: "icon")
  final String iconName;

  bool checkedIn = false;
  int checkInIn = 0;

  Point({
    this.uuid,
    this.name,
    this.description,
    this.geometry,
    this.segments,
    this.iconName
  });

  @override
  List<Object> get props => [uuid, name, description, geometry, segments, iconName];

  @override
  bool get stringify => true;

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  Map<String, dynamic> toJson() => _$PointToJson(this);
}

