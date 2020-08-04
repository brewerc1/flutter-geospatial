import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geometry.dart';

part 'alert.g.dart';

@immutable
@JsonSerializable()
class Alert extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "geometry")
  final Geometry geometry;

  @JsonKey(name: "icon")
  final String iconName;

  Alert({
    this.uuid,
    this.description,
    this.geometry,
    this.iconName
  });

  @override
  List<Object> get props => [uuid, description, geometry, iconName];

  @override
  bool get stringify => true;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  Map<String, dynamic> toJson() => _$AlertToJson(this);
}
