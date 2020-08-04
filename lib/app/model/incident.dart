import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'geometry.dart';

part 'incident.g.dart';

@immutable
@JsonSerializable()
class Incident extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "type")
  final String typeUuid;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "geometry")
  final Geometry geometry;

  @JsonKey(name: "photos")
  final String photo;

  Incident({
    this.uuid,
    this.typeUuid,
    this.description,
    this.geometry,
    this.photo
  });

  @override
  List<Object> get props => [uuid, typeUuid, description, geometry, photo];

  @override
  bool get stringify => true;

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentToJson(this);
}