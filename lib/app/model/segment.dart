import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'segment.g.dart';

@immutable
@JsonSerializable()
class Segment extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "points")
  final List<Point> points;

  @JsonKey(name: "points_rules")
  final List<String> pointRules;

  Segment({
    this.uuid,
    this.name,
    this.description,
    this.points,
    this.pointRules
  });

  @override
  List<Object> get props => [uuid, name, description, points];

  @override
  bool get stringify => true;

  factory Segment.fromJson(Map<String, dynamic> json) => _$SegmentFromJson(json);

  Map<String, dynamic> toJson() => _$SegmentToJson(this);

}