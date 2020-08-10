import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incident_type.g.dart';

@immutable
@JsonSerializable()
class IncidentType extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "title")
  final String title;

  IncidentType({
    this.uuid,
    this.title
  });

  @override
  List<Object> get props => [uuid, title];

  factory IncidentType.fromJson(Map<String, dynamic> json) => _$IncidentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentTypeToJson(this);

  bool operator ==(dynamic other) =>
      other != null && other is IncidentType && this.uuid == other.uuid;

  @override
  int get hashCode => super.hashCode;

}